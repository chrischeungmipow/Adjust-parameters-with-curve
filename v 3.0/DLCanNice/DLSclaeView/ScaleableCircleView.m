//
//  ScaleableCircleView.m
//
//  Created by vincent on 9/8/15.
//  Copyright (c) 2015 Mipow. All rights reserved.
//

#import "ScaleableCircleView.h"
#import "UIView+Extension.h"
#import "GlobalTool.h"

#define kWidth 150.0
#define kHeight 75
#define kSmallRadiu 5

@interface ScaleableCircleView ()

@property(nonatomic, assign) CGFloat smallRadiu;

@property(nonatomic, assign) CGFloat touchPosX;

@property(nonatomic, assign) CGFloat beginX;
@property(nonatomic, assign) CGFloat pointX;

@property(nonatomic, strong) UITouch *panTouch;

@end

@implementation ScaleableCircleView

+ (void)initialize {
  if (self == [ScaleableCircleView class]) {
    id appearance = [self appearance];
    [appearance setSizeRatio:0.5];
    [appearance setBackgroundColor:[UIColor clearColor]];
  }
}

- (instancetype)initWithFrame:(CGRect)frame {

  if (self = [super initWithFrame:frame]) {

    _scale = 1.0;
    _pointX = 0.0;
    self.clipsToBounds = NO;
    UIPanGestureRecognizer *pan =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handWithPan:)];
    [self addGestureRecognizer:pan];
  }
  return self;
}

- (void)handWithPan:(UIPanGestureRecognizer *)sender {
  CGFloat scale;

  CGPoint point = [sender translationInView:self];
  NSLog(@"point x: %f", point.x);
  NSLog(@"old point x: %f", self.pointX);

  if (self.beginX > 75) {

    scale = (self.width + (point.x - self.pointX))  / self.width ;

  } else {

    scale = (self.width - (point.x - self.pointX)) / self.width ;
  }

  if (self.width * scale > 227 || self.width * scale < 75)
    return;
  self.transform = CGAffineTransformScale(self.transform, scale, scale);

  self.pointX = point.x;
  self.scale = (self.width / 150.0 - 1) * 0.1 + 1;
  self.smallRadiu = scale * self.smallRadiu;
  [self scaleView:self.scale];
}

- (void)scaleView:(CGFloat)scale {
  if ([self.delegate respondsToSelector:@selector(scaleView:)]) {
    [self.delegate scaleView:scale];
  }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

  _pointX = 0.0;
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint begin = [touch locationInView:self];
  CGPoint end = [touch previousLocationInView:self];

  // if( self.width -begin.x + end.x < 225 && self.width -begin.x + end.x > 75)
  // NSLog(@"begin: %g", begin.x);
  // NSLog(@"end: %g", end.x);
  self.beginX = begin.x;
  self.touchPosX = (-begin.x + end.x) * 1.5;
}

- (void)drawRect:(CGRect)rect {

  //大圆
  drawArc(rect);

  //画线
  drawLine(rect);

  //右小圆
  drawCircle(YES, rect);

  //左小圆
  drawCircle(NO, rect);
}

- (void)setSizeRatio:(CGFloat)sizeratio {
  _sizeRatio = MIN(MAX(0.0f, sizeratio), 1.0f);
  [self setNeedsDisplay];
}
/**
 *  画线
 */
void drawLine(CGRect Rect) {
  // 获得图形上下文
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  // 设置线段宽度
  CGContextSetLineWidth(ctx, 1.0);

  // 设置线段头尾部的样式
  CGContextSetLineCap(ctx, kCGLineCapRound);

  // 设置线段转折点的样式
  CGContextSetLineJoin(ctx, kCGLineJoinRound);

  // 设置颜色
  [[UIColor whiteColor] set];
  // 设置一个起点
  CGContextMoveToPoint(ctx, kSmallRadiu, Rect.size.height / 2.0);
  // 添加一条线段
  CGContextAddLineToPoint(ctx, Rect.size.width - kSmallRadiu,
                          Rect.size.height / 2.0);

  // 渲染一次
  CGContextStrokePath(ctx);
}
/**
 *  画圆方法
 */
void drawCircle(BOOL isRight, CGRect Rect) {

  CGFloat diameter = kSmallRadiu * 2;
  // 1.获得上下文
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  // 2.画圆
  CGContextAddEllipseInRect(
      ctx,
      CGRectMake(isRight * Rect.size.width - pow(diameter, isRight) +
                     pow(-1, isRight),
                 Rect.size.height / 2.0 - kSmallRadiu, diameter, diameter));

  CGContextSetLineWidth(ctx, 1);

  [[UIColor whiteColor] set];

  // 3.显示所绘制的东西
  CGContextStrokePath(ctx);
}

/**
 *  画圆弧
 */
void drawArc(CGRect rect) {

  // 1.获得上下文
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  // 2.画弧线
  CGContextAddArc(ctx, rect.size.width / 2.0, rect.size.height / 2.0,
                  rect.size.height / 2.0, 0, 2 * M_PI, 0);
  // CGContextAddArc(ctx, rect.size.width /2, rect.size.height/2.0, 0 , 2 *
  // M_PI, 0);

  // 3.设置着色
  [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] set];

  // 4.显示所绘制的东西
  CGContextStrokePath(ctx);
}

@end
