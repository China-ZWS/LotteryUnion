//
//  BaseTextView.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-4-15.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BaseTextView.h"



@interface BaseTextView ()
{
    NSMutableArray *_insetsHeight;
}
@end

@implementation BaseTextView



- (void)dealloc
{
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
 }


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
//        [self getCornerRadius:5 borderColor:[UIColor lightGrayColor] borderWidth:1 masksToBounds:YES];
        self.backgroundColor = [UIColor clearColor];
        _insetsHeight = [NSMutableArray array];
        UIView *v=[[UIView alloc] init];
        CGRect rect=v.frame;
        rect.size.height=20;
        [v setFrame:rect];
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"jianpan_action"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        
        [self setInputAccessoryView:v];
        
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //
    if ([self.delegate respondsToSelector:@selector(calculateInsetHeight)] && [self.delegate conformsToProtocol:@protocol(BaseTextViewDelegate)])
    {
        [self.delegate calculateInsetHeight];

    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}


- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
}

-(void)hideKeyBoard:(id)sender
{
    [self resignFirstResponder];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
