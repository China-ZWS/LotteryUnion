//
//  BaseBettingField.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/9.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  numberSniperTextFild;
@protocol NumberSniperProtocol <NSObject>

- (void)numberHadChange:( numberSniperTextFild*)numberTectfield;

@end

@interface numberSniperTextFild: UITextField

@property (nonatomic) NSString *defaultText; //默认的数
@property (nonatomic) UIView *fatherView;
@property (nonatomic,weak)id<NumberSniperProtocol> NumberSniperDelegate;

/*输入框的大小和所在的父视图*/
- (id)initWithFrame:(CGRect)frame toView:(UIView *)view;

@end
