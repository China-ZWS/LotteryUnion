//
//  KeyBoard.m
//  keyBoard
//
//  Created by jamalping on 14-6-16.
//  Copyright (c) 2014年 jamalping. All rights reserved.
//

#import "KeyBoard.h"

#define HeightLightColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]

@implementation KeyBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 初始化子视图
        [self _initSubViews];
        
    }
    return self;
}

-(void)_initSubViews
{
    // 底图
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 131, mScreenWidth, mScreenHeight-130)];
    baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    // 底图的取消手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [baseView addGestureRecognizer:tap];
    [self addSubview:baseView];
    
    // 键盘视图
    UIView *keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, mScreenHeight-215, mScreenWidth, 216)];
    keyBoardView.backgroundColor = [UIColor grayColor];
    [self addSubview:keyBoardView];
    
    // 创建按钮
    int btnWidth = (mScreenWidth-1)/3;
    int btnHeight = (216 - 2)/4;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((btnWidth+0.5)*j, (btnHeight+0.5)*i+0.5, btnWidth, btnHeight);
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:30];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:button.frame.size] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:HeightLightColor size:button.frame.size] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[UIColor whiteColor]];
            // 第四行
            if (i == 3)
            {
                switch (j)
                {
                    case 0:
                    {
                        [button setTitle:@"删除" forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:21];
                        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:219/255.0 alpha:1] size:button.frame.size] forState:UIControlStateNormal];
                        [button setBackgroundColor:HeightLightColor];
                        [button addTarget:self action:@selector(deletesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    case 1:
                    {
                        [button setTitle:@"0" forState:UIControlStateNormal];
                        button.tag = 0;
                        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:button.frame.size] forState:UIControlStateNormal];
                        [button setBackgroundImage:[UIImage imageWithColor:HeightLightColor size:button.frame.size] forState:UIControlStateHighlighted];
                        [button addTarget:self action:@selector(numberButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    case 2:
                    {
                        [button setTitle:@"确定" forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:21];
                        [button setBackgroundColor:HeightLightColor];
                        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:219/255.0 alpha:1] size:button.frame.size] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(truesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    default:
                        break;
                }
            }
            else {
                button.tag = i*3+j+1;
                [button setTitle:[NSString stringWithFormat:@"%d",(int)button.tag] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(numberButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            [keyBoardView addSubview:button];
        }
    }
}

#pragma mark -----block赋值
-(void)numberButtonResult:(number)number
{
    self.number = number;
}
-(void)deletesButtonResult:(deletes)deletes
{
    self.deletes = deletes;
}
-(void)truesntruesButtonResult:(trues)trues
{
    self.trues = trues;
}

#pragma mark ----- ButtonAction
-(void)numberButtonAction:(UIButton *)button
{
    if (self.number != nil) {
        self.number(button);
    }
}

-(void)deletesButtonAction:(UIButton *)button
{
    if (self.deletes != nil) {
        self.deletes(button);
    }
}

-(void)truesButtonAction:(UIButton *)button
{
    if (self.trues != nil) {
        self.trues(button);
    }
}


// 显示
-(void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.top = mScreenHeight - self.height;
        [self setAlpha:1];
    }];
}

// 消失
-(void)dismiss
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.delegate.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0.0];
        self.top = mScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
