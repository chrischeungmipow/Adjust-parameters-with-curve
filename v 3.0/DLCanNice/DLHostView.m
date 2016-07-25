//
//  DLHostView.m
//  DLCanNice
//
//  Created by dengjie on 10/7/15.
//  Copyright © 2015 dengjie. All rights reserved.
//

#import "DLHostView.h"
#import "GrandView.h"
#import "GlobalTool.h"
#import "UIView+Extension.h"

@interface DLHostView ()<GRandViewDelegate>

@property(nonatomic,weak)UILabel * EQlabel;

@property(nonatomic,weak)UILabel *Glabel;

@property(nonatomic, weak)UILabel *HZlabel;

@end

@implementation DLHostView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getEQLabel:)
                                                 name:@"PointY"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getHZLabel:)
                                                 name:@"PointX"
                                               object:nil];
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentScale:) name:@"SavedScale" object:nil];
    GrandView *randView = [[GrandView alloc]
        initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];//0, 64, kScreenWidth, kScreenHeight - 64

    UIImageView *imageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, 104, kScreenWidth, 396)];
    imageView.image = [UIImage imageNamed:@"Background.png"];
    imageView.backgroundColor = [UIColor clearColor];

    [randView addSubview:imageView];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:frame];
    bgImageView.image = [UIImage imageNamed:@"bg.png"];
    bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgImageView];
    [self addSubview:randView];
    self.backgroundColor = [UIColor clearColor];
    [self addEQLable];
    randView.delegate = self;
  }
  return self;
}

-(void)getEQLabel:(NSNotification *)notification{
    
    float i=[notification.object floatValue];
    if (i > 12.0) {
        self.EQlabel.text=@"12.0";
    }else if (i < -12){
        self.EQlabel.text=@"-12.0";
    }else if ([notification.object isEqualToString:@"-0.0"] || [notification.object isEqualToString:@"0.0"]) {
        self.EQlabel.text=@"0.0";
    }else{
         self.EQlabel.text=[NSString stringWithFormat:@"%.1f",i];
    }
}
-(void)getHZLabel:(NSNotification *)notification{
    self.HZlabel.text=notification.object;
}


- (void)addEQLable
{
    //G:
    UILabel *EMarkLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 70, 60, 30)];
    EMarkLabel.textColor=[UIColor whiteColor];
    EMarkLabel.textAlignment=NSTextAlignmentLeft;
    EMarkLabel.text=@"G:";
    EMarkLabel.font=[UIFont systemFontOfSize:16.0];
    //Q:
    UILabel *QMarkLabel=[[UILabel alloc]initWithFrame:CGRectMake(220, 70, kScreenWidth/4, 30)];
    QMarkLabel.textColor=[UIColor whiteColor];
    QMarkLabel.textAlignment=NSTextAlignmentLeft;
    QMarkLabel.text=@"Q:";
    QMarkLabel.font=[UIFont systemFontOfSize:16.0];
    //HZ
    UILabel *HZMarkLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 70, 50, 30)];//kScreenWidth/4
    HZMarkLabel.textColor=[UIColor whiteColor];
    HZMarkLabel.textAlignment=NSTextAlignmentLeft;
    HZMarkLabel.text=@"Hz";
    HZMarkLabel.font=[UIFont systemFontOfSize:20.0];
    
    
    
    UILabel*EQLable = [[UILabel alloc]initWithFrame:CGRectMake(170, 70, 60, 30)];
    EQLable.textColor = [UIColor whiteColor];
    EQLable.textAlignment = NSTextAlignmentLeft;
    EQLable.font=[UIFont systemFontOfSize:16.0];
    //[EQLable addSubview:EMarkLabel];
    [self addSubview:EMarkLabel];
    [self addSubview:EQLable];
    self.EQlabel = EQLable ;
    UILabel *Glable = [[UILabel alloc]initWithFrame:CGRectMake(240, 70, self.EQlabel.width, 30)];
    Glable.textColor = [UIColor whiteColor];
    Glable.textAlignment = NSTextAlignmentLeft;
    Glable.font=[UIFont systemFontOfSize:16.0];
    //[Glable addSubview:QMarkLabel];
    [self addSubview:QMarkLabel];
    [self addSubview:Glable];
    self.Glabel = Glable;
    
    UILabel *HZlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 70, 30)];    HZlabel.textColor=[UIColor whiteColor];
    HZlabel.textAlignment=NSTextAlignmentRight;
    HZlabel.font=[UIFont systemFontOfSize:20.0];
    //[HZlabel addSubview:HZMarkLabel];
    [self addSubview:HZMarkLabel];
    [self addSubview:HZlabel];
    self.HZlabel=HZlabel;
}

- (void)moveScaleView:(GrandView *)grandView
{
    NSLog(@"--------%@",NSStringFromCGRect(grandView.frame));
}

- (void)scaleView:(CGFloat)scale
{
    NSLog(@"the scale is: %g",scale);
    NSInteger i=scale *1000;
    float m=((1050-i)*3.6/100) + 0.4;
    //结果保留1位小数
    self.Glabel.text=[NSString stringWithFormat:@"%.1f",m];
}

-(void)getCurrentScale:(NSNotification *)notification{
    
    NSInteger i=[notification.object floatValue] * 1000;    
    float m=((1050-i)*3.6/100) + 0.4;
    self.Glabel.text=[NSString stringWithFormat:@"%.1f",m];
    NSLog(@"当前的这个点的缩放值为-->%f",m);

}


@end
