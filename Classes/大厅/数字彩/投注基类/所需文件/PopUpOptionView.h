//
//  PopUpOptionView.h
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorLabel.h"

@interface PopUpOptionView : UIControl <UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *picker1;
    UIPickerView *picker2;
    UIView *containerView;
    
    NSUInteger _selectPickerIndex;
    NSArray *_data;

    
    NSUInteger _mutilpe;
    NSInteger _numOfPeriod;  //期数
    
    BOOL _unlimted;
}

- (id)initWithFrame:(CGRect)frame mutiple:(NSString *)mutiple period:(NSString *)period showFollowOption:(BOOL)showFollow;

@property (nonatomic,assign,readonly) NSUInteger mutiple;      //倍数
@property (nonatomic,assign,readonly) NSInteger numOfPeriod;   //期数

-(void)showInWindow;
@end
