//
//  FRPointView.m
//  fristDome
//
//  Created by dengjie on 15/7/29.
//  Copyright (c) 2015年 dengjie. All rights reserved.
//

#import "FRPointView.h"
#import "GlobalTool.h"
#import "UIView+Extension.h"

static CGFloat const RADIUS = 8;

@implementation FRPointView

+ (instancetype)share {
  FRPointView *aInstance = [[self alloc]
      initWithFrame:(CGRect){CGPointZero, CGSizeMake(RADIUS * 2, RADIUS * 2)}];
  aInstance.backgroundColor = [UIColor clearColor];
  aInstance.isSelect = NO;
  [aInstance addTarget:aInstance
                action:@selector(touchDragInside:withEvent:)
      forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
  [aInstance addTarget:aInstance
                action:@selector(test)
      forControlEvents:UIControlEventTouchDragOutside];
  aInstance.curScale = 1.0;
  return aInstance;
}

- (void)test {
  if (self.touchOutCallback)
      self.touchOutCallback(self);
}
/**
 *  事件响应
 *
 *  @param pointView 响应事件对你
 *  @param event     事件对像
 */
- (void)touchDragInside:(FRPointView *)pointView withEvent:(UIEvent *)event {

  self.isSelect = YES;
  
  CGPoint point =
      [[[event allTouches] anyObject] locationInView:self.superview];
    BOOL isMoveLeft =  point.x > self.center.x ? NO:YES;
    if(point.y < 137 ||  point.y > 458) return;//point.y < 0 ||  point.y > self.superview.height + 40
    
    self.center = point;

  if (self.dragCallBack)
      self.dragCallBack(self,isMoveLeft);
  [self setNeedsDisplay];
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

- (void)drawRect:(CGRect)rect {
  [self drawCircle];
}



- (void)drawCircle {
  // 1.获得上下文
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  // 2.画圆
  CGContextAddEllipseInRect(ctx, self.bounds);

  CGContextSetLineWidth(ctx, 1);

  CGFloat alpha = (self.isSelect) ? 1 : 0.5;

  [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:alpha] set];

  // 3.显示所绘制的东西
  CGContextFillPath(ctx);
}

- (void)dealloc
{
    [self removeTarget:self
                  action:@selector(touchDragInside:withEvent:)
        forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    [self removeTarget:self
                  action:@selector(test)
        forControlEvents:UIControlEventTouchDragOutside];
    
}

@end
