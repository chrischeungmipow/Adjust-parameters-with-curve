//
//  ViewController.m
//  DLCanNice
//
//  Created by dengjie on 9/21/15.
//  Copyright © 2015 dengjie. All rights reserved.
//

#import "ViewController.h"
#import "DLHostView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条的背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:0];
    //设置导航条的标题字体颜色和字体的大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    DLHostView *hostView = [[DLHostView  alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:hostView];
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(105, 520, 60, 28)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"Reset.png"] forState:UIControlStateNormal];
    saveBtn.backgroundColor=[UIColor clearColor];
    [self.view addSubview:saveBtn];
    
    UIButton *reSetBtn=[[UIButton alloc]initWithFrame:CGRectMake(150, 520, 60, 28)];
    [reSetBtn setBackgroundImage:[UIImage imageNamed:@"Save.png"] forState:UIControlStateNormal];
    reSetBtn.backgroundColor=[UIColor clearColor];
    [self.view addSubview:reSetBtn];

    
}






@end
