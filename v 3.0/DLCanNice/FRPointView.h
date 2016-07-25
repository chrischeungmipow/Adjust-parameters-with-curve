//
//  FRPointView.h
//  fristDome
//
//  Created by dengjie on 15/7/29.
//  Copyright (c) 2015年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPointView;

@interface FRPointView : UIControl

@property(nonatomic,assign)BOOL isSelect;

/**
 *  工厂方法
 *
 *  @return 方法一个FRPointView
 */
+ (instancetype)share;
/**
 *  回调Block
 */
@property (nonatomic,copy) void (^dragCallBack)(FRPointView * pointView,BOOL isMoveLeft);
/**
 *  回调Block
 */
@property (nonatomic,copy) void (^touchOutCallback)(FRPointView *pointView);
/**
 *  曲率
 */
@property (nonatomic,assign)CGFloat curScale;

@end
