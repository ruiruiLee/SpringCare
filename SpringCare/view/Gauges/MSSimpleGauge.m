//
//  PBSimpleGauge.m
//  SimpleGauge
//
//  Created by Mike Sabatini on 1/9/13.
//  Copyright (c) 2013 Mike Sabatini. All rights reserved.
//

#import "MSSimpleGauge.h"
#import "MSArcLayer.h"
#import "MSGradientArcLayer.h"
#import <QuartzCore/QuartzCore.h>
#import "define.h"

#define M_PI 3.14159265358979323846264338327950288
#define DEGREES_TO_RADIANS(angle) (angle * (M_PI/180))

#define NEEDLE_BASE_WIDTH_RATIO .14

@interface MSSimpleGauge ()
@property (nonatomic) CALayer *containerLayer;
@property (nonatomic) MSGradientArcLayer *valueArcLayer;
@property (nonatomic) MSGradientArcLayer *backgroundArcLayer;

@property (nonatomic) MSGradientArcLayer *backgroundArcLayer1;
@property (nonatomic) MSGradientArcLayer *backgroundArcLayer2;
@property (nonatomic) MSGradientArcLayer *backgroundArcLayer3;
@property (nonatomic) MSGradientArcLayer *backgroundArcLayer4;
@property (nonatomic) MSGradientArcLayer *backgroundArcLayer5;
@property (nonatomic) MSGradientArcLayer *backgroundArcLayer6;

@end

@implementation MSSimpleGauge
#pragma mark - Initialization / Construction
- (void)setup
{
    _minValue = 0;
    _maxValue = 100;
//    _value = 0;
    
//    _startAngle = 0;
//    _endAngle = 180;
    
    _arcThickness = 50;

    _backgroundArcFillColor = [UIColor redColor];//[UIColor colorWithRed:.82 green:.82 blue:.82 alpha:1];
    _backgroundArcStrokeColor = [UIColor whiteColor];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat needleWidth = width * NEEDLE_BASE_WIDTH_RATIO;
//    if(!_needleView)
    [_needleView removeFromSuperview];
    
    _needleView = [[MSNeedleView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 needleWidth,
                                                                 width/2+4)];
//    else
//        _needleView.frame = CGRectMake(0,
//                                       0,
//                                       needleWidth,
//                                       width/2+4);
    if ( [_needleView respondsToSelector:@selector(contentScaleFactor)] )
    {
        _needleView.contentScaleFactor = [[UIScreen mainScreen] scale];
    }
    [self addSubview:_needleView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _needleView.layer.anchorPoint = CGPointMake(.5, (height-(needleWidth/2))/height);
    _needleView.center = CGPointMake(width/2, height);
    
    float newAngle = [self angleForValue:_value];
    
    [self rotateNeedleByAngle:-90+_startAngle + newAngle];
    
    if(!_containerLayer)
        _containerLayer = [CALayer layer];
    _containerLayer.frame = CGRectMake(0, 0, width, height);
    [self.layer insertSublayer:_containerLayer atIndex:0];
    [self setupArcLayers];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _startAngle = 40;
        _endAngle = 140;
        _value = 0;
        
        [self setup];
    }
    return self;
}

#pragma mark - Private / Protected
- (void)setValue:(id)value forKey:(NSString *)key animated:(BOOL)animated
{
    // half second duration or none depending on animated flag
    float duration = animated ? .5 : 0;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self setValue:value forKey:key];
                     }
                     completion:^(BOOL finished) {
                     }];
}


- (void)rotateNeedleByAngle:(float)angle
{
    CATransform3D rotatedTransform = self.needleView.layer.transform;
    rotatedTransform = CATransform3DRotate(rotatedTransform, DEGREES_TO_RADIANS(angle), 0.0f, 0.0f, 1.0f);
    self.needleView.layer.transform = rotatedTransform;
}

- (void)setupArcLayers
{
    _backgroundArcLayer = [MSGradientArcLayer layer];
    _backgroundArcLayer.strokeColor = _backgroundArcStrokeColor;
    _backgroundArcLayer.fillColor = _backgroundArcFillColor;
    _backgroundArcLayer.gradient = _backgroundGradient;
    _backgroundArcLayer.strokeWidth = 1.0;
    _backgroundArcLayer.arcThickness = _arcThickness;
    _backgroundArcLayer.startAngle = DEGREES_TO_RADIANS((_startAngle+180));
    _backgroundArcLayer.endAngle = DEGREES_TO_RADIANS((_endAngle+180));
    _backgroundArcLayer.bounds = _containerLayer.bounds;
    _backgroundArcLayer.anchorPoint = CGPointZero;
    if ( [_backgroundArcLayer respondsToSelector:@selector(contentsScale)] )
    {
        _backgroundArcLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    [_containerLayer addSublayer:_backgroundArcLayer];
    
    CGFloat angle = 180.0/8.0;
    
    //1
    _backgroundArcLayer1 = [MSGradientArcLayer layer];
    _backgroundArcLayer1.strokeColor = _backgroundArcStrokeColor;
    _backgroundArcLayer1.fillColor = _COLOR(71, 173, 242);//_backgroundArcFillColor;
    _backgroundArcLayer1.gradient = _backgroundGradient;
    _backgroundArcLayer1.strokeWidth = 1.0;
    _backgroundArcLayer1.arcThickness = _arcThickness;
    _backgroundArcLayer1.startAngle = DEGREES_TO_RADIANS((_startAngle+180));
    _backgroundArcLayer1.endAngle = DEGREES_TO_RADIANS((_startAngle+180 + angle)) + angle;
    _backgroundArcLayer1.bounds = _containerLayer.bounds;
    _backgroundArcLayer1.anchorPoint = CGPointZero;
    if ( [_backgroundArcLayer1 respondsToSelector:@selector(contentsScale)] )
    {
        _backgroundArcLayer1.contentsScale = [[UIScreen mainScreen] scale];
    }
    [_containerLayer addSublayer:_backgroundArcLayer1];
    //2
    _backgroundArcLayer2 = [MSGradientArcLayer layer];
    _backgroundArcLayer2.strokeColor = _backgroundArcStrokeColor;
    _backgroundArcLayer2.fillColor = _COLOR(46, 203, 121);//_backgroundArcFillColor;
    _backgroundArcLayer2.gradient = _backgroundGradient;
    _backgroundArcLayer2.strokeWidth = 1.0;
    _backgroundArcLayer2.arcThickness = _arcThickness;
    _backgroundArcLayer2.startAngle = DEGREES_TO_RADIANS((_startAngle+180 + angle));
    _backgroundArcLayer2.endAngle = DEGREES_TO_RADIANS((_startAngle+180 + 4 *angle));
    _backgroundArcLayer2.bounds = _containerLayer.bounds;
    _backgroundArcLayer2.anchorPoint = CGPointZero;
    if ( [_backgroundArcLayer2 respondsToSelector:@selector(contentsScale)] )
    {
        _backgroundArcLayer2.contentsScale = [[UIScreen mainScreen] scale];
    }
    [_containerLayer addSublayer:_backgroundArcLayer2];
    //3
    _backgroundArcLayer3 = [MSGradientArcLayer layer];
    _backgroundArcLayer3.strokeColor = _backgroundArcStrokeColor;
    _backgroundArcLayer3.fillColor = _COLOR(253, 198, 63);//_backgroundArcFillColor;
    _backgroundArcLayer3.gradient = _backgroundGradient;
    _backgroundArcLayer3.strokeWidth = 1.0;
    _backgroundArcLayer3.arcThickness = _arcThickness;
    _backgroundArcLayer3.startAngle = DEGREES_TO_RADIANS((_startAngle+180 + 4 * angle));
    _backgroundArcLayer3.endAngle = DEGREES_TO_RADIANS((_startAngle+180+ 5 *angle));
    _backgroundArcLayer3.bounds = _containerLayer.bounds;
    _backgroundArcLayer3.anchorPoint = CGPointZero;
    if ( [_backgroundArcLayer3 respondsToSelector:@selector(contentsScale)] )
    {
        _backgroundArcLayer3.contentsScale = [[UIScreen mainScreen] scale];
    }
    [_containerLayer addSublayer:_backgroundArcLayer3];
    //4
    _backgroundArcLayer4 = [MSGradientArcLayer layer];
    _backgroundArcLayer4.strokeColor = _backgroundArcStrokeColor;
    _backgroundArcLayer4.fillColor = _COLOR(253, 126, 55);//_backgroundArcFillColor;
    _backgroundArcLayer4.gradient = _backgroundGradient;
    _backgroundArcLayer4.strokeWidth = 1.0;
    _backgroundArcLayer4.arcThickness = _arcThickness;
    _backgroundArcLayer4.startAngle = DEGREES_TO_RADIANS((_startAngle+180 + 5 * angle));
    _backgroundArcLayer4.endAngle = DEGREES_TO_RADIANS((_startAngle+180+ 6 * angle)) ;
    _backgroundArcLayer4.bounds = _containerLayer.bounds;
    _backgroundArcLayer4.anchorPoint = CGPointZero;
    if ( [_backgroundArcLayer4 respondsToSelector:@selector(contentsScale)] )
    {
        _backgroundArcLayer4.contentsScale = [[UIScreen mainScreen] scale];
    }
    [_containerLayer addSublayer:_backgroundArcLayer4];
    //5
    _backgroundArcLayer5 = [MSGradientArcLayer layer];
    _backgroundArcLayer5.strokeColor = _backgroundArcStrokeColor;
    _backgroundArcLayer5.fillColor = _COLOR(252, 78, 81);//_backgroundArcFillColor;
    _backgroundArcLayer5.gradient = _backgroundGradient;
    _backgroundArcLayer5.strokeWidth = 1.0;
    _backgroundArcLayer5.arcThickness = _arcThickness;
    _backgroundArcLayer5.startAngle = DEGREES_TO_RADIANS((_startAngle+180+ 6 * angle)) ;
    _backgroundArcLayer5.endAngle = DEGREES_TO_RADIANS((_startAngle+180+ 7 * angle));
    _backgroundArcLayer5.bounds = _containerLayer.bounds;
    _backgroundArcLayer5.anchorPoint = CGPointZero;
    if ( [_backgroundArcLayer5 respondsToSelector:@selector(contentsScale)] )
    {
        _backgroundArcLayer5.contentsScale = [[UIScreen mainScreen] scale];
    }
    [_containerLayer addSublayer:_backgroundArcLayer5];
    //6
    _backgroundArcLayer6 = [MSGradientArcLayer layer];
    _backgroundArcLayer6.strokeColor = _backgroundArcStrokeColor;
    _backgroundArcLayer6.fillColor = _COLOR(227, 42, 47);//_backgroundArcFillColor;
    _backgroundArcLayer6.gradient = _backgroundGradient;
    _backgroundArcLayer6.strokeWidth = 1.0;
    _backgroundArcLayer6.arcThickness = _arcThickness;
    _backgroundArcLayer6.startAngle = DEGREES_TO_RADIANS((_startAngle+180+ 7 * angle));
    _backgroundArcLayer6.endAngle = DEGREES_TO_RADIANS((_endAngle+180));
    _backgroundArcLayer6.bounds = _containerLayer.bounds;
    _backgroundArcLayer6.anchorPoint = CGPointZero;
    if ( [_backgroundArcLayer6 respondsToSelector:@selector(contentsScale)] )
    {
        _backgroundArcLayer6.contentsScale = [[UIScreen mainScreen] scale];
    }
    [_containerLayer addSublayer:_backgroundArcLayer6];
    
    _valueArcLayer = [MSGradientArcLayer layer];
    _valueArcLayer.strokeColor = _fillArcStrokeColor;
    _valueArcLayer.fillColor = _fillArcFillColor;
    _valueArcLayer.gradient = _fillGradient;
    _valueArcLayer.arcThickness = _arcThickness;
    _valueArcLayer.startAngle = DEGREES_TO_RADIANS((_startAngle+180));
    _valueArcLayer.endAngle = DEGREES_TO_RADIANS((_startAngle+180));
    _valueArcLayer.bounds = _containerLayer.bounds;
    _valueArcLayer.anchorPoint = CGPointZero;
    if ( [_valueArcLayer respondsToSelector:@selector(contentsScale)] )
    {
        _valueArcLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    [_containerLayer addSublayer:_valueArcLayer];
}

- (void)fillUpToAngle:(float)angle
{
    if ( _valueArcLayer )
    {
//        _valueArcLayer.endAngle = DEGREES_TO_RADIANS((angle+180));
    }
}

- (float)angleForValue:(float)value
{
    float ratio = (value - _minValue) / (_maxValue - _minValue);
    float angle = _startAngle + ((_endAngle - _startAngle) * ratio);
    return angle;
}

#pragma mark - Setters
- (void)setArcThickness:(float)arcThickness
{
    if ( _arcThickness != arcThickness )
    {
        _arcThickness = arcThickness;
        [self setNeedsDisplay];
    }
}

- (void)setStartAngle:(float)startAngle
{
    if ( _startAngle != startAngle )
    {
        float oldNeedleAngle = [self angleForValue:self.value];
        
        _startAngle = startAngle;
        _backgroundArcLayer.startAngle = DEGREES_TO_RADIANS((_startAngle+180));
        _valueArcLayer.startAngle = DEGREES_TO_RADIANS((_startAngle+180));
        
        float newNeedleAngle = [self angleForValue:self.value];
        float newAngle = newNeedleAngle - oldNeedleAngle;
        [self rotateNeedleByAngle:newAngle];
    }
}

- (void)setEndAngle:(float)endAngle
{
    if ( _endAngle != endAngle )
    {
        float oldNeedleAngle = [self angleForValue:self.value];
        
        _endAngle = endAngle;
        _backgroundArcLayer.endAngle = DEGREES_TO_RADIANS((_endAngle+180));
        _valueArcLayer.endAngle = DEGREES_TO_RADIANS((oldNeedleAngle+180));
        
        float newNeedleAngle = [self angleForValue:self.value];
        float newAngle = newNeedleAngle - oldNeedleAngle;
        [self rotateNeedleByAngle:newAngle];
    }
}

- (void)setMinValue:(float)minValue
{
    if ( _minValue != minValue )
    {
        // don't let the min value be greater than the max value
        minValue = minValue > _maxValue ? _maxValue : minValue;
        _minValue = minValue;
    }
}

- (void)setMaxValue:(float)maxValue
{
    if ( _maxValue != maxValue )
    {
        // don't let the max value be lower then the min value
        maxValue = maxValue < _minValue ? _minValue : maxValue;
        _maxValue = maxValue;
    }
}

- (void)setValue:(float)value
{
    if ( _value != value )
    {
        // setting value above the max value sets to max value
        value = value > _maxValue ? _maxValue : value;
       
        // setting value below the min value set to min value
        value = value < _minValue ? _minValue : value;
        
        float oldValue = _value < _minValue ? _minValue : _value;
        float oldAngle = [self angleForValue:oldValue];
        float newAngle = [self angleForValue:value];
        _value = value;
        
        [self rotateNeedleByAngle:newAngle - oldAngle];
//        [self fillUpToAngle:newAngle];
    }
}

- (void)setBackgroundArcFillColor:(UIColor *)backgroundArcFillColor
{
    _backgroundArcLayer.fillColor = backgroundArcFillColor;
}

- (void)setBackgroundArcStrokeColor:(UIColor *)backgroundArcStrokeColor
{
    _backgroundArcLayer.strokeColor = backgroundArcStrokeColor;
}

- (void)setFillArcFillColor:(UIColor *)foregroundArcFillColor
{
    _valueArcLayer.fillColor = foregroundArcFillColor;
}

- (void)setFillArcStrokeColor:(UIColor *)foregroundArcStrokeColor
{
    _valueArcLayer.strokeColor = foregroundArcStrokeColor;
}

- (void)setFillGradient:(CGGradientRef)fillGradient
{
    _valueArcLayer.gradient = fillGradient;
}

- (void)setBackgroundGradient:(CGGradientRef)backgroundGradient
{
    _backgroundArcLayer.gradient = backgroundGradient;
}

#pragma mark - Animated Setters
- (void)setValue:(float)value animated:(BOOL)animated
{
    [self setValue:@(value) forKey:@"value" animated:animated];
}

- (void)setEndAngle:(float)endAngle animated:(BOOL)animated
{
    [self setValue:@(endAngle) forKey:@"endAngle" animated:animated];
}

- (void)setStartAngle:(float)startAngle animated:(BOOL)animted
{
    [self setValue:@(startAngle) forKey:@"startAngle" animated:animted];
}
@end
