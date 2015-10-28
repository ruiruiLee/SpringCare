//
//  HealthRecordDetail.m
//  SpringCare
//
//  Created by LiuZach on 15/10/12.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import "HealthRecordDetail.h"
#import "UIImageView+WebCache.h"

#define colorblue _COLOR(71, 173, 242)

@implementation HealthRecordData

@end

@implementation HealthRecordDetail
@synthesize data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnLeft setBackgroundImage:nil forState:UIControlStateNormal];
    [self.btnLeft setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.NavigationBar.hidden = YES;
    
    _headerView = [[UIView alloc] init];
    [self.ContentView addSubview:_headerView];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerView.backgroundColor = colorblue;
    
    //header
    _photoImagv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_headerView addSubview:_photoImagv];
    _photoImagv.translatesAutoresizingMaskIntoConstraints = NO;
    _photoImagv.clipsToBounds = YES;
    _photoImagv.layer.cornerRadius = 50;
    [_photoImagv sd_setImageWithURL:[NSURL URLWithString:self.lover.photoUrl] placeholderImage:ThemeImage(@"placeholderimage")];
    
    _lbLover = [self createLabel:_headerView];
    _lbLover.font = _FONT(20);
    _lbLover.text = self.lover.username;
    
    _lbDBP = [self createLabel:_headerView];
    _lbDBP.font = _FONT(30);
    _lbDBP.text = data.lp;
    
    _lbDBPText = [self createLabel:_headerView];
    _lbDBPText.font = _FONT(13);
    _lbDBPText.text = @"舒张压/mmHg";
    
    _lbSBP = [self createLabel:_headerView];
    _lbSBP.font = _FONT(30);
    _lbSBP.text = data.hp;
    
    _lbSBPText = [self createLabel:_headerView];
    _lbSBPText.font = _FONT(13);
    _lbSBPText.text = @"收缩压/mmHg";
    
    _lbHeartRate = [self createLabel:_headerView];
    _lbHeartRate.font = _FONT(30);
    _lbHeartRate.text = data.pulse;
    
    _lbHeartRateText = [self createLabel:_headerView];
    _lbHeartRateText.font = _FONT(13);
    _lbHeartRateText.text = @"心率/bpm";
    
    //-----------------------
    _dateImgv = [[UIImageView alloc] init];
    [self.ContentView addSubview:_dateImgv];
    _dateImgv.translatesAutoresizingMaskIntoConstraints = NO;
    _dateImgv.image = ThemeImage(@"dateLogo");
    
    _lbDate = [self createLabel:self.ContentView];
    _lbDate.font = _FONT(13);
    _lbDate.text = [data.dateString substringToIndex:10];
    _lbDate.textColor = _COLOR(0x99, 0x99, 0x99);
    
    _timeImgv = [[UIImageView alloc] init];
    [self.ContentView addSubview:_timeImgv];
    _timeImgv.translatesAutoresizingMaskIntoConstraints = NO;
    _timeImgv.image = ThemeImage(@"timeLogo");
    
    _lbTime = [self createLabel:self.ContentView];
    _lbTime.font = _FONT(13);
    _lbTime.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbTime.text = [data.dateString substringFromIndex:10];
    
    _detailInfo = [self createLabel:self.ContentView];
    _detailInfo.numberOfLines = 0;
    _detailInfo.font = _FONT(14);
    _detailInfo.textAlignment = NSTextAlignmentLeft;
    _detailInfo.textColor = _COLOR(0x66, 0x66, 0x66);
    _detailInfo.preferredMaxLayoutWidth = ScreenWidth - 60;
    _detailInfo.text = [self getDetailInfoWithSBP:[data.hp integerValue] DBP:[data.lp integerValue]];
    
    _gauge = [[MSSimpleGauge alloc] initWithFrame:CGRectZero];
    _gauge.startAngle = 0;
    _gauge.endAngle = 180;
//    _gauge.value = 0;
    [self.ContentView addSubview:_gauge];
    _gauge.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbStatus = [self createLabel:self.ContentView];
    _lbStatus.font = _FONT(30);
    _lbStatus.text = [self getStatusByBP:[data.hp integerValue] DBP:[data.lp integerValue]];
    _lbStatus.textColor = _COLOR(0x55, 0x55, 0x55);
    
    _lbdatas = [self createLabel:self.ContentView];
    _lbdatas.font = _FONT(30);
//    _lbdatas.text = [NSString stringWithFormat:@"%@/%@ mmHg", data.hp, data.lp];//@"113/46 mmhg";
    _lbdatas.textColor = _COLOR(0x99, 0x99, 0x99);
    
    NSString *labelText = [NSString stringWithFormat:@"%@/%@ mmHg", data.hp, data.lp];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    [attributedString addAttribute:NSFontAttributeName value:_FONT(13) range:NSMakeRange([labelText length] - 4, 4)];
    _lbdatas.attributedText = attributedString;
    
    _rateImgv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_rateImgv];
    _rateImgv.translatesAutoresizingMaskIntoConstraints = NO;
    _rateImgv.image = ThemeImage(@"heartLogo");
    
    _lbRate = [self createLabel:self.ContentView];
    _lbRate.font = _FONT(13);
    _lbRate.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbRate.text = [self getRateWithRate:[data.pulse integerValue]];
    
    UIView *left = [[UIView alloc] init];
    left.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ContentView addSubview:left];
    UIView *right = [[UIView alloc] init];
    right.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ContentView addSubview:right];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_headerView, _photoImagv, _lbLover, _lbDBP, _lbSBP, _lbDBPText, _lbSBPText, _lbHeartRate, _lbHeartRateText, _dateImgv, _lbDate, _timeImgv, _detailInfo, _gauge, _lbStatus, _lbdatas, _rateImgv, _lbRate, _lbTime, left, right);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_headerView]-0-|" options:0 metrics:nil views:views]];
    
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if (type == EnumValueTypeiPhone4S) {
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headerView(224)]-15-[_dateImgv]-4-[_gauge(130)]-6-[_rateImgv]-6-[_detailInfo]->=0-|" options:0 metrics:nil views:views]];
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_gauge]-30-|" options:0 metrics:nil views:views]];
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_photoImagv(100)]-6-[_lbLover]-8-[_lbSBP]-8-[_lbSBPText]->=6-|" options:0 metrics:nil views:views]];
        _lbStatus.font = _FONT(24);
        _lbdatas.font = _FONT(24);
        NSString *labelText = [NSString stringWithFormat:@"%@/%@ mmHg", data.hp, data.lp];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        [attributedString addAttribute:NSFontAttributeName value:_FONT(12) range:NSMakeRange([labelText length] - 4, 4)];
        _lbdatas.attributedText = attributedString;
    }else if(type == EnumValueTypeiPhone5)
    {
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headerView(268)]-15-[_dateImgv]-20-[_gauge(140)]-6-[_rateImgv]-10-[_detailInfo]->=0-|" options:0 metrics:nil views:views]];
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_gauge]-20-|" options:0 metrics:nil views:views]];
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_photoImagv(100)]-10-[_lbLover(24)]-30-[_lbSBP(24)]-14-[_lbSBPText(14)]->=14-|" options:0 metrics:nil views:views]];
    }
    else if (type == EnumValueTypeiPhone6){
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headerView(278)]-20-[_dateImgv]-30-[_gauge(180)]-10-[_rateImgv]-20-[_detailInfo]->=0-|" options:0 metrics:nil views:views]];
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_gauge]-20-|" options:0 metrics:nil views:views]];
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_photoImagv(100)]-10-[_lbLover(24)]-30-[_lbSBP(24)]-14-[_lbSBPText(14)]->=14-|" options:0 metrics:nil views:views]];
    }
    else if (type == EnumValueTypeiPhone6P){
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_headerView(278)]-20-[_dateImgv]-30-[_gauge(210)]-10-[_rateImgv]-20-[_detailInfo]->=0-|" options:0 metrics:nil views:views]];
        [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_gauge]-20-|" options:0 metrics:nil views:views]];
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_photoImagv(100)]-10-[_lbLover(24)]-30-[_lbSBP(24)]-14-[_lbSBPText(14)]->=14-|" options:0 metrics:nil views:views]];
    }
    
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_dateImgv]-8-[_lbDate]->=10-[_timeImgv]-8-[_lbTime]-20-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_detailInfo]-30-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbDate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_dateImgv attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeImgv attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_dateImgv attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_dateImgv attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbRate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_rateImgv attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[left]-0-[_rateImgv]-8-[_lbRate]-0-[right]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:left attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:right attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    //header
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_lbLover]-60-|" options:0 metrics:nil views:views]];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_lbSBP]-10-[_lbDBP]-10-[_lbHeartRate]-10-|" options:0 metrics:nil views:views]];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_lbSBPText]-10-[_lbDBPText]-10-[_lbHeartRateText]-10-|" options:0 metrics:nil views:views]];
    
    NSString *format = [NSString stringWithFormat:@"H:|-%f-[_photoImagv(100)]-%f-|", (ScreenWidth-100)/2, (ScreenWidth-100)/2];
    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbDBP attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbSBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeartRate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbSBP attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbDBP attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbSBP attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeartRate attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbSBP attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbDBPText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbSBPText attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeartRateText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbSBPText attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbDBPText attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbSBPText attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeartRateText attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_lbSBPText attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_lbStatus]-80-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_lbdatas]-80-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbdatas attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:_gauge attribute:NSLayoutAttributeBaseline multiplier:1 constant:-4]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbStatus]-4-[_lbdatas]->=0-|" options:0 metrics:nil views:views]];
    
    _gauge.value = [self getValueWIthSBP:[data.hp integerValue] DBP:[data.lp integerValue]];
    
    NSInteger level = [self getLevelWIthSBP:[data.hp integerValue] DBP:[data.lp integerValue]];
    if(level == 1){
        _headerView.backgroundColor = _COLOR(71, 173, 242);
    }
    else if (level == 2){
        _headerView.backgroundColor = _COLOR(46, 203, 121);
    }
    else if (level == 3){
        _headerView.backgroundColor = _COLOR(253, 198, 63);
    }
    else if (level == 4){
        _headerView.backgroundColor = _COLOR(253, 126, 55);
    }
    else if (level == 5){
        _headerView.backgroundColor = _COLOR(252, 78, 81);
    }
    else{
        _headerView.backgroundColor = _COLOR(227, 42, 47);
    }
}

- (UILabel *)createLabel:(UIView *)root
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    [root addSubview:lb];
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    lb.textColor = [UIColor whiteColor];
    lb.textAlignment = NSTextAlignmentCenter;
    
    return lb;
}

- (void) LeftButtonClicked:(id)sender{
    [super LeftButtonClicked:sender];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getRateWithRate:(NSInteger) rate
{
    if(rate < 60)
        return @"心率：偏低";
    else if (rate > 100)
        return @"心率：偏高";
    else
        return @"心率：正常";
}
/**
 sbp 收缩压
 dbp 舒张压
 */
- (NSString *)getStatusByBP:(NSInteger) sbp DBP:(NSInteger) dbp
{
    if(sbp <= 89)
        return @"偏低";
    else if (sbp >= 200 || dbp >= 130)
        return @"危险";
    else if (sbp >= 180 || dbp >= 110)
        return @"超高";
    else if ((sbp >= 160 && sbp <= 179) || ( dbp >= 100 && dbp <= 109))
        return @"过高";
    else if ((sbp >= 140 && sbp <= 159) || (dbp >= 90 && dbp <= 99))
        return @"偏高";
    else if (sbp < 140 && sbp >= 90 && dbp <= 90)
        return @"正常";
    return @"";
}
/**
 sbp 收缩压
 dbp 舒张压
 */
- (NSString *)getDetailInfoWithSBP:(NSInteger) sbp DBP:(NSInteger) dbp
{
    if(sbp <= 89)
        return @"此次血压低于正常范围，请从饮食、生活方式、是否药物过量及自身有无不适等多方面查找原因。如有疑问及时就医。";
    else if (sbp >= 200 || dbp >= 130)
        return @"该监测对像此次血压极高，应立即就医。";
    else if (sbp >= 180 || dbp >= 110)
        return @"该监测对像已达到三级高血压诊断标准，请及时就医。";
    else if (sbp < 140 && sbp >= 90 && dbp <= 90)
        return @"血压正常";
    else if ((sbp >= 140 && sbp <= 159) || (dbp >= 90 && dbp <= 99))
        return @"此次血压高于正常范围，已达到一级高血压诊断标准，请从饮食、生活方式、药物治疗方面查找原因。如有疑问及时就医。";
    else if ((sbp >= 160 && sbp <= 179) ||( dbp >= 100 && dbp <= 109))
        return @"该监测对像此次血压明显高于正常范围，已达到二级高血压诊断标准，请从饮食、生活方式、药物治疗方面查找原因。如有疑问及时就医。";
    return @"";
}
/**
 sbp 收缩压
 dbp 舒张压
 */
- (CGFloat)getValueWIthSBP:(NSInteger) sbp DBP:(NSInteger) dbp
{
    CGFloat scale = 0.0f;
    
    HealthRecordData *item = [self getHealthRecordDataWIthSBP:sbp DBP:dbp];
    
    CGFloat scale1 = (dbp - item.bmpmin) / (item.bmpmax - item.bmpmin);
    CGFloat scale2 = (sbp- item.sbpmin) / (item.sbpmax - item.sbpmin);
    if(scale1 > scale2)
        scale = scale1;
    else
        scale = scale2;
    
    NSInteger level = [self getLevelWIthSBP:[data.hp integerValue] DBP:[data.lp integerValue]];
    if(level == 2){
        return 3 * scale * 100.0 / 8.0 + item.ChartStartValue;
    }
    else
        return scale * 100.0 / 8.0 + item.ChartStartValue;
}
/**
 sbp 收缩压
 dbp 舒张压
 */
- (NSInteger) getLevelWIthSBP:(NSInteger) sbp DBP:(NSInteger) dbp
{
    if(sbp <= 89)
        return 1;
    else if (sbp < 140 && sbp >= 90 && dbp <= 90)
        return 2;
    else if (sbp >= 200 || dbp >= 130)
        return 6;
    else if (sbp >= 180 || dbp >= 110)
        return 5;
    else if ((sbp >= 160 && sbp <= 179) || ( dbp >= 100 && dbp <= 109))
        return 4;
    else
        return 3;
}

/**
 sbp 收缩压
 dbp 舒张压
 */
- (HealthRecordData *) getHealthRecordDataWIthSBP:(NSInteger) sbp DBP:(NSInteger) dbp
{
    HealthRecordData *data = [[HealthRecordData alloc] init];
    
    if(sbp <= 89)
    {
        data.level = 1;
        data.ChartStartValue = 0;
        data.sbpmin = 0;
        data.sbpmax = 89;
        
        data.bmpmin = 0;
        data.bmpmax = 1000;
    }
    else if (sbp < 140 && sbp >= 90 && dbp <= 90)
    {
        data.level = 2;
        data.ChartStartValue = 100.0/8.0;
        data.sbpmin = 90;
        data.sbpmax = 139;
        
        data.bmpmin = 0;
        data.bmpmax = 90;
    }
    else if (sbp >= 200 || dbp >= 130)
    {
        data.level = 6;
        data.ChartStartValue = 700.0/8.0;
        data.sbpmin = 200;
        data.sbpmax = 1000;
        
        data.bmpmin = 130;
        data.bmpmax = 1000;
    }
    else if (sbp >= 180 || dbp >= 110)
    {
        data.level = 5;
        data.ChartStartValue = 600.0/8.0;
        data.sbpmin = 180;
        data.sbpmax = 199;
        
        data.bmpmin = 110;
        data.bmpmax = 129;
    }
    else if ((sbp >= 160 && sbp <= 179) || ( dbp >= 100 && dbp <= 109))
    {
        data.level = 4;
        data.ChartStartValue = 500.0/8.0;
        data.sbpmin = 160;
        data.sbpmax = 179;
        
        data.bmpmin = 100;
        data.bmpmax = 109;
    }
    else
    {
        data.level = 3;
        data.ChartStartValue = 50;
        data.sbpmin = 140;
        data.sbpmax = 159;
        
        data.bmpmin = 90;
        data.bmpmax = 99;
    }
    
    return data;
}

@end
