//
//  RecoderAndPlayer.m
//  shareApp
//
//  Created by share02 on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecoderAndPlayer.h"
#include <stdio.h> 
#include <stdlib.h>
#import "amrFileCodec.h"

#define FILEPATH [chat_VoiceCache_path stringByAppendingPathComponent:[self fileNameString]]
#define WAVE_UPDATE_FREQUENCY   0.05
@implementation RecoderAndPlayer

@synthesize recorder,session;
@synthesize playpath,player;
@synthesize recordAudioName,recordAmrName;
@synthesize delegate;
@synthesize aSeconds;

+ (id)sharedRecoderAndPlayer {
    static RecoderAndPlayer* recoderAndPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recoderAndPlayer = [[RecoderAndPlayer alloc] init];
    });
    return recoderAndPlayer;
}

- (id)init {
    if (self = [super init]) {
        //存放目录
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:chat_VoiceCache_path]) {
            [fm createDirectoryAtPath:chat_VoiceCache_path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

//格式化录制文件名称 距离1970的毫秒数 10位整数
- (NSString *) fileNameString
{
    NSString *fileName= [CommonMethod getTimeAndRandom];
    recordAudioName= [[NSString alloc] initWithFormat:@"%@.%@",fileName,@"wav"];
    recordAmrName= [[NSString alloc] initWithFormat:@"%@.%@",fileName,@"amr"];
    return recordAudioName;
}

//录音
-(BOOL)record
{
	NSError *error;
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSURL *urlPath = [NSURL fileURLWithPath:FILEPATH];
	self.recorder = [[[AVAudioRecorder alloc] initWithURL:urlPath settings:settings error:&error] autorelease];
	if (!self.recorder)
	{
		return NO;
	}
	self.recorder.delegate = self;
	if (![self.recorder prepareToRecord])
	{
		return NO;
	}
    self.recorder.meteringEnabled = YES; //允许波形
  //  [self.recorder recordForDuration:(NSTimeInterval) 60];
	if (![self.recorder record])
	{
		return NO;
	}
    [self LoudSpeakerRecorder:YES];
	return YES;
  }

//删除临时文件
- (void)removeTempFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempFile = [chat_VoiceCache_path stringByAppendingPathComponent:recordAudioName];
    [fileManager removeItemAtPath:tempFile error:nil];
}



- (BOOL) startAudioSession
{
	NSError *error;
	self.session = [AVAudioSession sharedInstance];
	if (![self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
	{
		return NO;
	}
	if (![self.session setActive:YES error:&error])
	{
		return NO;
	}
	return self.session.inputIsAvailable;
}

- (void) play
{
	if (self.player) [self.player play];
  
}

- (BOOL) prepAudio
{
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:self.playpath]) return NO;
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.playpath] error:&error];
	if (!self.player)
	{
		return NO;
	}
	
	[self.player prepareToPlay];
	self.player.meteringEnabled = YES;
	self.player.delegate = self;
    [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
	return YES;
}


/**
 @Brief 音频解码
 **/
-(NSData *)decodeToWAVE:(NSData *)data{
    if (!data) {
        return data;
    }
    return DecodeAMRToWAVE(data);
}
/**
 @Brief 音频转码
 **/
-(NSData*)encodeToAMR:(NSData*)data voiceName:(NSString*)amrName {
    if (!data) {
        return data;
    }
    return EncodeWAVEToAMR(data, 1, 16,amrName);
}

//录音计时
-(void)countTime{
    if (self.aSeconds>=SpeechMaxTime) {
        self.aSeconds = SpeechMaxTime;
       [self stopRecording];
    }else {
        aSeconds+= WAVE_UPDATE_FREQUENCY;
        /*  发送TimePromptAction代理来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        if (self.recorder) {
            [self.recorder updateMeters];
        }
        
        float peakPower = [self.recorder averagePowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        if ([delegate respondsToSelector:@selector(TimePromptAction:peakPower:)]) {
            [delegate TimePromptAction:self.aSeconds peakPower:peakPowerForChannel];
        }
    }
 
}

/**
 @Brief 开始录音
 **/
-(void)startRecording{
    if (player) {
        [player stop];
    }
    //录制
    isPlay = NO;
    if ([self startAudioSession]) {
    self.aSeconds=0;
    [self record];
    timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    }
}

/**
 @Brief 停止录音
 **/
-(void)stopRecording{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    self.recorder = nil;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

/**
 @Brief 播放录音
 **/
-(void)startPlaying:(NSString *)amrFile{
    if (player) {
        [player stop];
    }
    NSData *amrData ;
    if ([amrFile hasSuffix:@".amr"]) {
        amrData = [NSData dataWithContentsOfFile:[chat_VoiceCache_path stringByAppendingPathComponent:amrFile]];
    }
    else{
     amrData = [NSData dataWithContentsOfFile:[chat_VoiceCache_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",amrFile]]];
    }
    NSData *wavData = [self decodeToWAVE:amrData];
    if (!wavData) {
        NSLog(@"wavdata is empty");
        return;
    }
    [self LoudSpeakerPlay:YES];
    player= [[AVAudioPlayer alloc] initWithData:wavData error:nil];
    [player stop];
    player.delegate =self;
    [player prepareToPlay];
    [player setVolume:1.0];
    [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
}

/**
 @Brief 停止播放
 **/
- (void)stopPlaying {
    if (player) {
        [player stop];
        player.delegate = nil;
    }
}

//打开扬声器--录音
-(bool) LoudSpeakerRecorder:(bool)bOpen
{
	//播放的时候设置play ，录音时候设置recorder
	
    UInt32 route;   
    UInt32 sessionCategory =  kAudioSessionCategory_PlayAndRecord; // 1
    
    AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,                        // 2
                                     sizeof (sessionCategory),                                   // 3
                                     &sessionCategory                                            // 4
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    return true;
}

//打开扬声器--播放
-(bool) LoudSpeakerPlay:(bool)bOpen
{
	//播放的时候设置play ，录音时候设置recorder
	
	//return false;
    UInt32 route;
    //OSStatus error;    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;// kAudioSessionCategory_PlayAndRecord;//kAudioSessionCategory_RecordAudio;//kAudioSessionCategory_PlayAndRecord;    // 1
    
     AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,                        // 2
                                     sizeof (sessionCategory),                                   // 3
                                     &sessionCategory                                            // 4
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
     AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    return true;
}


#pragma mark -
#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSData *adata = [NSData dataWithContentsOfFile:[chat_VoiceCache_path stringByAppendingPathComponent:recordAudioName]];
    
    if (self.aSeconds>=2) {
        //音频转码
        adata = [self encodeToAMR:adata voiceName:recordAmrName];
    }
    //删除临时文件
    [self removeTempFile];
    if ([delegate respondsToSelector:@selector(recordAndSendAudioFile:duration:fileName:)]) {
        [delegate recordAndSendAudioFile:adata duration:(int)self.aSeconds fileName:recordAmrName];
      }
   }

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isPlay = NO;
    //播放完成回调
    if ([delegate respondsToSelector:@selector(playingFinishWithVoice:)]) {
        [delegate playingFinishWithVoice:YES];
    }
}

@end
