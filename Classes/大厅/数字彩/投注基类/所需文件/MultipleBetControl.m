//
//  MultipleBetView.m
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "MultipleBetControl.h"
#import "CustomSwitch.h"
#define Print_text_color [UIColor purpleColor]
@interface MultipleBetControl () <CustomSwitchDelegate>



@end

@implementation MultipleBetControl
@synthesize follow_type = _follow_type;
@synthesize follow_prize = _follow_prize;

- (id)initWithFrame:(CGRect)frame showFollowOption:(BOOL)showFollow
      isAutoGerenal:(BOOL)_isAuto {
    self = [super initWithFrame:frame];
    if (self) {
        _isAuotoGereral = _isAuto;
        CGRect bgFrame = CGRectMake(5.0,0.0,315.0,self.height);
        bgView = [[UIImageView alloc] initWithFrame:bgFrame];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        
        ColorLabel *l1 = [[ColorLabel alloc] initWithFrame:CGRectMake(5,5,40,25)        text:LocStr(@"倍数:") color:Print_text_color];
        [l1 setCenterY:bgView.height/2];
        l1.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:l1];
        
        mutlipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mutlipeButton setTitle:[NSString stringWithFormat:@"%d倍",1]
                       forState:UIControlStateNormal];
        [mutlipeButton addTarget:self action:@selector(showPicker:)
                forControlEvents:UIControlEventTouchUpInside];
        [mutlipeButton setSpinnerStyle];
        [mutlipeButton setTag:0];
        
        CGFloat button_width = 100;
        mutlipeButton.frame = CGRectMake(l1.right,l1.top,button_width,25);
        [mutlipeButton setCenterY:bgView.height/2];
        [bgView addSubview:mutlipeButton];
        
        if (showFollow) {
            ColorLabel *l2 = [[ColorLabel alloc] initWithFrame:l1.frame    text:LocStr(@"追号:") color:Print_text_color];
            [l2 setLeft:mutlipeButton.right+20];
            [l2 setFont:l1.font];
            [bgView addSubview:l2];
            
            followButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [followButton setTitle:LocStr(@"请选择") forState:UIControlStateNormal];
            [followButton addTarget:self action:@selector(showPicker:)
                   forControlEvents:UIControlEventTouchUpInside];
            [followButton setSpinnerStyle];
            [followButton setFrame:mutlipeButton.frame];
            [followButton setLeft:l2.right];
            [followButton setTag:1];
            [bgView addSubview:followButton];
        }
    }
    return self;
}
#pragma mark -- 弹出自定制的键盘
- (void)showPicker:(id)sender
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonEnable
{

}

- (void)setMutipleValue:(int)mutilpe {
    [mutlipeButton setTitle:[NSString stringWithFormat:@"%d倍",mutilpe]
                   forState:UIControlStateNormal];
}

- (void)setPeriod:(int)period
{
    if (period == -1) {
        [followButton setTitle:LocStr(@"无限期") forState:UIControlStateNormal];
        [self showFollowOptionWithAutoFollow:_isAuotoGereral];
    } else if (period == 0) {
        [followButton setTitle:@"请选择" forState:UIControlStateNormal];
    } else {
        [followButton setTitle:[NSString stringWithFormat:@"%d期",period] forState:UIControlStateNormal];
        if (period > 0)
            [self showFollowOptionWithAutoFollow:_isAuotoGereral];
        else {
            [bgView setHeight:CONTROL_HEIGHT];
           if (optionView) [optionView removeFromSuperview];
        }
    }
}

- (void)removeFollowOptionView:(CGFloat)height {
    [optionView removeFromSuperview];

    [bgView setHeight:height];
    [self setHeight:height];
}

- (void)showFollowOptionWithAutoFollow:(BOOL)isAutoSelected {
    if (optionView) {
        [optionView removeFromSuperview];
    }
    
    if(!isAutoSelected)
        return;

    optionView = [[UIView alloc] initWithFrame:CGRectMake(0,mutlipeButton.bottom,mScreenWidth-10,30)];
    optionView.backgroundColor = [UIColor clearColor];
    
    ColorLabel *lblContinue = [[ColorLabel alloc] initWithFrame:CGRectMake(5,0,100,20) text:LocStr(@"中奖继续追号") color:Print_text_color];
    [lblContinue setFont:[UIFont systemFontOfSize:14]];
    [lblContinue setCenterY:optionView.height/2];
    [optionView addSubview:lblContinue];
    
    CGRect sw1Frame = CGRectMake(bgView.width-76.0,lblContinue.top,0,0);
    UISwitch *sw1 = [[UISwitch alloc] initWithFrame:sw1Frame];
    
    [sw1 addTarget:self action:@selector(switchChanged:)
              forControlEvents:UIControlEventValueChanged];
    [sw1 setTransform:CGAffineTransformMakeScale(0.7, 0.7)];
    [sw1 setOnTintColor:[UIColor orangeColor]];
    [sw1 setCenterY:optionView.height/2];
    [sw1 setOn:YES];
    [sw1 setTag:0];
    
    // 初始化switch（自定义的switch）
//    _switchOne = [[CustomSwitch alloc] initWithFrame:CGRectMake(bgView.width-90, lblContinue.top, 0, 0)];
//    _switchOne.delegate = self;
//    _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
//    _switchOne.backgroundColor = [UIColor clearColor];
//    _switchOne.onImage = [UIImage imageNamed:@"switcher_on_down"];
//    _switchOne.offImage = [UIImage imageNamed:@"switcher_off_down"];
//    _switchOne.size = CGSizeMake(_switchOne.offImage.width, _switchOne.onImage.height);
//    _switchOne.status = CustomSwitchStatusOn;
//    [optionView addSubview:_switchOne];
    
    [optionView addSubview:sw1];
    [bgView addSubview:optionView];
    [bgView setHeight:CONTROL_HEIGHT+30];
    [self setHeight:CONTROL_HEIGHT+30];
}

- (void)switchChanged:(UISwitch *)sender {
    if (sender.tag == 0)
        _follow_prize = sender.on ? 0 : 1;
    else if (sender.tag == 1)
        _follow_type = sender.on ? 1 : 0;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - customSwitch delegate
/*
-(void)customSwitchSetStatus:(CustomSwitchStatus)status
{
    switch (status) {
        case CustomSwitchStatusOn:
            _follow_prize = 0;
            _follow_type = 0;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
        case CustomSwitchStatusOff:
            _follow_prize = -1;
            _follow_type = 0;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
        default:
            break;
    }
}
 */

@end
