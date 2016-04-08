//
//  MultipleBetView.h
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorLabel.h"

#define CONTROL_HEIGHT 25
@class CustomSwitch;
@interface MultipleBetControl : UIControl 
{
    NSUInteger _selectPickerIndex;
    UIImageView *bgView;
    UIButton *mutlipeButton;
    UIButton *followButton;
    
    UIView *optionView;
    
    NSInteger _follow_prize;
    NSInteger _follow_type; 
    BOOL _isAuotoGereral;
}

@property (strong, nonatomic) IBOutlet CustomSwitch *switchOne;
@property (nonatomic, readonly) NSInteger follow_prize;
@property (nonatomic, readonly) NSInteger follow_type;

- (id)initWithFrame:(CGRect)frame showFollowOption:(BOOL)showFollow isAutoGerenal:(BOOL)_isAuto;

- (void)setMutipleValue:(int)mutilpe;
- (void)setPeriod:(int)period;
- (void)showFollowOptionWithAutoFollow:(BOOL)isAutoSelected;
- (void)removeFollowOptionView:(CGFloat)height;

@end
