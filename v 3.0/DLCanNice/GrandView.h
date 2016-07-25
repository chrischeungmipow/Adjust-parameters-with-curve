//
//  GrandView.h
//  渐变
//
//  Created by vincent on 9/22/15.
//  Copyright © 2015 Mipow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPointView;
@class GrandView;

@protocol GRandViewDelegate <NSObject>

- (void)moveScaleView:(GrandView*)grandView;
- (void)scaleView:(CGFloat)scale;

@end


@interface GrandView : UIView
/**
 *  曲线路径
 */
@property (nonatomic,strong)UIBezierPath *curvePath;
/**
 *  当前选择点
 */
@property (nonatomic,strong)FRPointView  *curSlectPoint;
/**
 *  代理对像
 */
@property (nonatomic,weak) id<GRandViewDelegate> delegate;

@end
