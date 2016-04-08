//
//  KeyBoard.h
//  keyBoard
//
//  Created by jamalping on 14-6-16.
//  Copyright (c) 2014年 jamalping. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyBoard;

typedef void (^number)(UIButton *numberButton);
typedef void (^deletes)(UIButton *deleteButton);
typedef void (^trues)(UIButton *truesButton);

@interface KeyBoard : UIView

@property(nonatomic,copy) number  number;  // 数字按钮回调
@property(nonatomic,copy) deletes deletes; // 删除按钮回调
@property(nonatomic,copy) trues   trues;   // 确定按钮回调

@property(nonatomic,strong)UIViewController*delegate;

-(void)numberButtonResult:(number)number;
-(void)deletesButtonResult:(deletes)deletes;
-(void)truesntruesButtonResult:(trues)trues;

-(void)show;

-(void)dismiss;

@end
