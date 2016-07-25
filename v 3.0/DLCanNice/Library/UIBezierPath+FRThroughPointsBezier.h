//
//  UIBezierPath+FRThroughPointsBezier.h
//  fristDome
//
//  Created by dengjie on 15/7/29.
//  Copyright (c) 2015年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (FRThroughPointsBezier)
/**
 *  曲线的弯曲程序,默认是0.7
 */
@property (nonatomic) CGFloat contractionFactor;

/**
 *  通点支点绘制曲线
 *
 *  @param pointArray 点集合
 */
- (void)addBezierThroughPoints:(NSArray *)pointArray;

@end
