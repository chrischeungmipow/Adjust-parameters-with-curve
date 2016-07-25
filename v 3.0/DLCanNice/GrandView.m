
//
//  GrandView.m
//  渐变
//
//  Created by vincent on 9/22/15.
//  Copyright © 2015 Mipow. All rights reserved.
//

#import "GrandView.h"
#import "FRPointView.h"
#import "GlobalTool.h"
#import "ScaleableCircleView.h"
#import "UIView+Extension.h"
#import "UIBezierPath+FRThroughPointsBezier.h"

typedef void (^dragCallBack)(FRPointView *pointView, BOOL isMoveLeft);
typedef void (^touchOutCallback)(FRPointView *pointView);

@interface GrandView () <ScaleableCircleView>
/**
 *  控制视图
 */
@property(nonatomic, strong) ScaleableCircleView *scaleView;
/**
 *  控制点数组
 */
@property(nonatomic, strong) NSMutableArray *pointViewArray;
/**
 *  定时器
 */
@property(nonatomic, strong) NSTimer *timer;
/**
 *  控制点Block语句
 */
@property(nonatomic, copy) dragCallBack pointDrageCallBack;
/**
 *  控制点Block语句
 */
@property(nonatomic, copy) touchOutCallback pointTouchOutCallBack;
/**
 *  是否停止移动
 */
@property(nonatomic, assign) BOOL isMove;

@end

@implementation GrandView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self == [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];
    [self addContrellerPoints];
    [self addSubview:self.scaleView];
    self.scaleView.delegate = self;
    _isMove = NO;
  }
  return self;
}

- (void)scaleView:(CGFloat)scale {
  self.curSlectPoint.curScale = self.scaleView.scale;
  [self sliderValueChanged:[_pointViewArray indexOfObject:self.curSlectPoint]
                      move:YES];
  if ([self.delegate respondsToSelector:@selector(scaleView:)]) {
    [self.delegate scaleView:scale];
  }
}

- (NSMutableArray *)pointViewArray {
  if (!_pointViewArray) {
    _pointViewArray = [NSMutableArray array];
  }
  return _pointViewArray;
}

- (dragCallBack)pointDrageCallBack {
  __weak typeof(self) weak = self;
  __strong typeof(self) strong = weak;
  if (!_pointDrageCallBack) {
    _pointDrageCallBack = ^(FRPointView *pointView, BOOL isMoveLeft) {
      weak.curSlectPoint.isSelect = NO;
      [weak.curSlectPoint setNeedsDisplay];
      weak.curSlectPoint = pointView;
      pointView.isSelect = YES;

      [weak bringSubviewToFront:pointView];
      weak.scaleView.scale = pointView.curScale;
        NSNumber *scaleObj=[NSNumber numberWithFloat:pointView.curScale];
        
      [[NSNotificationCenter defaultCenter]postNotificationName:@"SavedScale" object:scaleObj];
      weak.scaleView.width = ((pointView.curScale - 1) * 10 + 1) * 150;
      weak.scaleView.height = ((pointView.curScale - 1) * 10 + 1) * 75;
      weak.scaleView.center = pointView.center;

      if ([weak.delegate respondsToSelector:@selector(moveScaleView:)]) {
        [weak.delegate moveScaleView:weak];
      }

      weak.scaleView.hidden = NO;
      [strong sliderValueChanged:[weak.pointViewArray indexOfObject:pointView]
                            move:isMoveLeft];
      [pointView setNeedsDisplay];

    };
  }
  return _pointDrageCallBack;
}

- (touchOutCallback)pointTouchOutCallBack {

  __weak typeof(self) weak = self;

  if (!_pointTouchOutCallBack) {
    _pointTouchOutCallBack = ^(FRPointView *pointView) {

      [weak.timer invalidate];
      weak.timer = nil;
      weak.timer =
          [NSTimer scheduledTimerWithTimeInterval:2.0
                                           target:weak
                                         selector:@selector(hideScaleView)
                                         userInfo:nil
                                          repeats:NO];

    };
  }
  return _pointTouchOutCallBack;
}
/**
 *  创建起终点
 */
- (void)addContrellerPoints {
  self.pointViewArray = [[NSMutableArray alloc] init];

  NSMutableArray *pointValueArray = [NSMutableArray array];

  for (int i = 0; i < 2; i++) {
    FRPointView *pointView = [FRPointView share];

    pointView.hidden = YES;

    pointView.center = CGPointMake(i * kScreenWidth, kStartY);

    pointView.dragCallBack = self.pointDrageCallBack;

    pointView.touchOutCallback = nil;

    [self addSubview:pointView];
    [self.pointViewArray addObject:pointView];

    [pointValueArray addObject:[NSValue valueWithCGPoint:pointView.center]];
  }
}

/**
 *  隐藏控制视图
 */
- (void)hideScaleView {

  self.scaleView.hidden = YES;
}

- (void)sliderValueChanged:(NSInteger)index move:(BOOL)isMoveLeft {

  if (index >= kNumCount || index < 0)
    return;
  [self.curvePath removeAllPoints];
  self.curvePath.contractionFactor = self.curSlectPoint.curScale;

  NSMutableArray *pointsAarry = [NSMutableArray array];
  FRPointView *firstPointView = _pointViewArray.firstObject;
  FRPointView *fontPoint = _pointViewArray[index - 1];
  FRPointView *lastPoint = _pointViewArray[index + 1];
  FRPointView *curPoint = _pointViewArray[index];
  CGFloat curX = curPoint.x + 10 * pow(-1, isMoveLeft);
  if (!(fontPoint.x < curX && curX < lastPoint.x)) {
    curPoint.dragCallBack = nil;
    curPoint.touchOutCallback = nil;
    [curPoint removeFromSuperview];
    _scaleView.hidden = YES;
    [_pointViewArray removeObject:curPoint];
    self.curSlectPoint = nil;
  }

  [self.curvePath moveToPoint:firstPointView.center];

  for (FRPointView *pointView in _pointViewArray) {

    [pointsAarry addObject:[NSValue valueWithCGPoint:pointView.center]];
  }
  [self.curvePath addBezierThroughPoints:pointsAarry];

  [self setNeedsDisplay];
}


#pragma sclaeView 的代理方法

- (ScaleableCircleView *)scaleView {
  if (!_scaleView) {
    CGRect rect = CGRectMake(0, 0, 150, 75);
    ScaleableCircleView *ScaleView =
        [[ScaleableCircleView alloc] initWithFrame:rect];
    self.scaleView = ScaleView;
    self.scaleView.hidden = YES;
    
  }
  return _scaleView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint centerPoint = [touch locationInView:self];
    if (_pointViewArray.count >= kNumCount || centerPoint.y < 64)
        return;
    FRPointView *pointView = nil;
    __block BOOL isControll = NO;
    
    if (2 < self.pointViewArray.count) {
        [_pointViewArray
         enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
             if (centerPoint.x < obj.center.x) {
                 UIView *obj_1 = _pointViewArray[idx - 1];
                 if (centerPoint.x < obj.center.x - 36 &&
                     centerPoint.x > obj_1.center.x + 36) {
                     CGFloat K = (obj.center.y - obj_1.center.y) /
                     (obj.center.x - obj_1.center.x);
                     CGFloat b = ((obj.center.y + obj_1.center.y) -
                                  K * (obj.center.x + obj_1.center.x)) /
                     2.0;
                     CGFloat pos = centerPoint.y - K * centerPoint.x - b;
                     if (pos < 25 && pos > -25) {
                         isControll = YES;
                     }
                     *stop = YES;
                 }
             }
         }];
    }
    
    if (!(isControll == YES || 2 == self.pointViewArray.count))
        return;
    _isMove = YES;
    pointView = [FRPointView share];
    pointView.dragCallBack = self.pointDrageCallBack;
    pointView.touchOutCallback = self.pointTouchOutCallBack;
    pointView.center = centerPoint;
    self.curSlectPoint.isSelect = NO;
    [self.curSlectPoint setNeedsDisplay];
    self.curSlectPoint = pointView;
    pointView.isSelect = YES;
    self.scaleView.hidden = NO;
    self.scaleView.width = 150;
    self.scaleView.height = 75;
    self.scaleView.center = centerPoint;
    [self addSubview:pointView];
    
    [_pointViewArray insertObject:pointView atIndex:_pointViewArray.count - 1];
    [_pointViewArray sortUsingComparator:^NSComparisonResult(FRPointView *obj1,
                                                             FRPointView *obj2) {
        return obj1.center.x > obj2.center.x;
    }];
    self.curvePath = [UIBezierPath bezierPath];
    [self sliderValueChanged:[_pointViewArray indexOfObject:pointView] move:YES];
    
    

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];

  if (!_isMove)
    return;
  CGPoint point = [touch previousLocationInView:self];
      if(point.y < 137 ||  point.y > 458) return;
  self.curSlectPoint.center = point;
  if (self.curSlectPoint == nil)
    return;

  self.curSlectPoint.dragCallBack(self.curSlectPoint, YES);
    NSUInteger yCount=point.y;
    
    if (yCount < 296) {
        //在平衡线上方
        NSString *pointY=[NSString stringWithFormat:@"%.1f",(float)(296 - yCount) / 13];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointY" object:pointY];
    }else{
        //在平衡线下方
        NSString *pointY=[NSString stringWithFormat:@"%@%.1f",@"-",(float)(yCount - 296) / 13];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointY" object:pointY];
    }
    
    NSInteger mCount=point.x;
    
    if (mCount < 80) {
        //这是0到100的范围
        NSInteger xCount=point.x * 1.2;
        NSString *pointX=[NSString stringWithFormat:@"%d",(int)xCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointX" object:pointX];
    }else if (mCount >= 80 && mCount < 160){
        //这是100到1000的范围
        NSInteger xCount1=(point.x - 80) * 12.5 + 100;
        NSString *pointX=[NSString stringWithFormat:@"%d",(int)xCount1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointX" object:pointX];
    }else if (mCount >= 160 && mCount < 240){
        //这是1000到10K的范围
        NSInteger xCount=(point.x - 160) * 123.8 + 1000;
        NSString *pointX=[NSString stringWithFormat:@"%d",(int)xCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointX" object:pointX];
    }else if (mCount >= 240 && mCount < 320){
        //这是10K到20K的范围
        NSInteger xCount=(point.x - 240) * 125 + 10000;
        NSString *pointX=[NSString stringWithFormat:@"%d",(int)xCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointX" object:pointX];
    }

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  _isMove = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches
               withEvent:(UIEvent *)event {
  _isMove = NO;
}

/**
 *  绘制渐变色
 *
 *  @param rect 范围
 */
- (void)drawRect:(CGRect)rect {
  if (!self.curvePath)
    return;
  //创建Quartz上下文
  CGContextRef context = UIGraphicsGetCurrentContext();
  //创建色彩空间对象
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  //创建起点颜色
  CGColorRef beginColor = CGColorCreate(
      colorSpaceRef, (CGFloat[]){0.01f, 0.09f, 0.91f, 0.5f}); //蓝色
  //创建终点颜色   黄色：0.99f, 0.99f, 0.01f, 1.0f
  CGColorRef endColor =
      CGColorCreate(colorSpaceRef, (CGFloat[]){1.0f, 1.0f, 1.0f, 0.2f});
  //创建颜色数组
  CFArrayRef colorArray = CFArrayCreate(
      kCFAllocatorDefault, (const void *[]){beginColor, endColor}, 2, nil);
  //创建渐变对象
  CGGradientRef grandientRef = CGGradientCreateWithColors(
      colorSpaceRef, colorArray, (CGFloat[]){
                                     0.0f, // 对应起点颜色位置0.0f
                                     1.0f  // 对应终点颜色位置1.0f
                                 });

  CFArrayRef colorArray2 = CFArrayCreate(
      kCFAllocatorDefault, (const void *[]){beginColor, endColor}, 2, nil);
  CGGradientRef grandientRef2 = CGGradientCreateWithColors(
      colorSpaceRef, colorArray2, (CGFloat[]){
                                      0.0f, // 对应起点颜色位置0.0f
                                      1.0f  // 对应终点颜色位置1.0f
                                  });

  //释放颜色数组
  CFRelease(colorArray);
  CFRelease(colorArray2);
  // 释放起点和终点颜色
  CGColorRelease(beginColor);
  CGColorRelease(endColor);
  //释放色彩空间
  CGColorSpaceRelease(colorSpaceRef);
  UIBezierPath *path = self.curvePath;

  path.lineWidth = 2; //如果要控制线条的粗细  就改变这个数值
  UIColor *color = [UIColor whiteColor]; //线条的颜色  改变这个数值
  [color set];

  [path stroke];

  [path addClip];
  CGContextSaveGState(context);

  CGContextDrawLinearGradient(context, grandientRef,
                              CGPointMake(kScreenWidth, 0.0f),
                              CGPointMake(kScreenWidth, kScreenWidth), 0);

  CGContextDrawLinearGradient(
      context, grandientRef2,
      CGPointMake(kStartY, kScreenHeight),    // kStartY, kScreenHeight
      CGPointMake(kStartY, kScreenWidth), 0); // kStartY, kScreenWidth

  //释放渐变对象
  CGGradientRelease(grandientRef);
  CGGradientRelease(grandientRef2);
}
@end
