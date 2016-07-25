//
//  DLRadiuView.m
//  DLCanNice
//
//  Created by dengjie on 10/21/15.
//  Copyright © 2015 dengjie. All rights reserved.
//

#import "DLRadiuView.h"

@implementation DLRadiuView

- (void)drawRect:(CGRect)rect {

}

- (void)drawCircle {
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.画圆
    CGContextAddEllipseInRect(ctx, self.bounds);
    
    CGContextSetLineWidth(ctx, 1);
    
    [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1] set];
    
    // 3.显示所绘制的东西
    CGContextFillPath(ctx);
}




@end
