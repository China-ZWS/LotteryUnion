//
//  FollowControl.m
//  ydtctz
//
//  Created by 小宝 on 1/19/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "FollowControl.h"

#define CHOOSEPICNAME  @"dlt_zhuijia_circle1"
#define NOMALPICNAME  @"dlt_zhuijia_circle"

#define Print_text_color [UIColor redColor]
@implementation FollowControl
{
    UIImageView *chooseImageView;  //选中视图

}
- (id)initWithFrame:(CGRect)_frame title:(NSString *)title aDefaultOn:(BOOL)isChoose
{
    self = [super initWithFrame:_frame];
    if (self) {
        
        //背景图片
        CGRect bgFrame = CGRectMake(0,0.0,self.width,self.height);
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:bgFrame];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.userInteractionEnabled = YES;
       // bgView.selected = isChoose;
        [self addSubview:bgView];
        
        //按钮
        UIButton *t3 = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height/2.0-10, self.width,20)];
        t3.backgroundColor = [UIColor clearColor];
        t3.selected = isChoose;
        [t3 addTarget:self action:@selector(chooseStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:t3];
        
        //选中标识图标
        chooseImageView = [[UIImageView alloc] initWithFrame:mRectMake(t3.width/2.0-50, 3, 16, 16)];
        chooseImageView.image = [UIImage imageNamed:(t3.isSelected?CHOOSEPICNAME:NOMALPICNAME)];
        [t3 addSubview:chooseImageView];
        
        //标题
        UILabel *titLab = [[UILabel alloc]initWithFrame:mRectMake(chooseImageView.right+5,chooseImageView.origin.y+1.8,t3.width-chooseImageView.right-5,t3.height)];
        titLab.font = [UIFont systemFontOfSize:14];
        titLab.text = title;
        [titLab sizeToFit];
        titLab.backgroundColor  =[UIColor clearColor];
        titLab.textColor  =BLACKFONTCOLOR1;
        [t3 addSubview:titLab];
        
    }
    return self;
}
- (void)chooseStatusChanged:(UIControl*)sender
{
    sender.selected = !sender.isSelected;
    chooseImageView.image = [UIImage imageNamed:(sender.isSelected?CHOOSEPICNAME:NOMALPICNAME)];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
