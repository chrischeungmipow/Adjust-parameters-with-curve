//
//  ScaleableCircleView.h
//  跟杰哥合并的代码
//
//  Created by vincent on 9/8/15.
//  Copyright (c) 2015 Mipow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScaleableCircleView <NSObject>
/**
 *  缩放时调用
 *
 *  @param scale 缩放的比例
 */
- (void)scaleView:(CGFloat)scale;

@end

@interface ScaleableCircleView : UIView
/**
 *  缩放比例
 */
@property (nonatomic,assign) CGFloat sizeRatio;
/**
 *  线条颜色
 */
@property (nonatomic,strong) UIColor *lineColor;
/**
 *  线条宽度
 */
@property (nonatomic,assign) CGFloat  lineWidth ;
/**
 *  旋转方向
 */
@property (nonatomic,assign) BOOL crvRotation;

@property (nonatomic,assign) CGFloat scale;

@property (nonatomic,weak) id<ScaleableCircleView> delegate;
@end
