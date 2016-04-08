//
//  UICustomDialog.h
//  Workout
//
//  Created by liuchan on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BetResult.h"  //投注结果

enum {
    topPos = 0,
    centerPos = 1,
    bottomPos = 2
}ContentPosition;

@interface UICustomDialog : UIView<UITableViewDataSource,UITableViewDelegate>{
    UIImageView *container;
    UIView *titleView;
    UIView *contentView;
    UIView *bottomView;
    
    UIButton *okButton;
    UIButton *closeButton;
    UIButton *cancelButton;
    UIImageView *iconView;
    
    UITableView *_betsTable;
    NSArray *_betsArray;
}

@property (nonatomic,readonly) UILabel *messageLabel;
@property (nonatomic,readonly) UILabel *titleLabel;
@property (nonatomic,readonly) UIButton *okButton;
@property (nonatomic,readonly) UIButton *cancelButton;
@property (nonatomic) BOOL isShowing;

// 设置OK按钮
-(UICustomDialog*)setOkButton:(NSString*)okTitle nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor target:(id)target action:(SEL)action;


-(UICustomDialog*)setCancelButton:(NSString*)cancelTitle nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor target:(id)target action:(SEL)action;

-(UICustomDialog*)setIcon:(UIImage*)icon;
-(UICustomDialog *)setTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(NSTextAlignment)titleAlignment titleFont:(UIFont *)titleFont;
-(UICustomDialog*)setMessage:(NSString*)message;
-(UICustomDialog *)setMessage:(NSString *)message autoHeight:(BOOL)isAuto;

-(UICustomDialog*)setContentView:(UIView*)v atPos:(int)pos;
-(void)setBetArray:(NSArray*)theArray;

-(void)show;
-(void)dismiss;
-(void)hideOkButton;
-(void)showCloseButton;
-(void)hideCancelButton;
-(void)dismissWitoutAnimation;

-(id)initWithHeight:(int)height;

@end
