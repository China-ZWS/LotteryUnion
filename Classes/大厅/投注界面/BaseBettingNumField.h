//
//  BaseBettingField.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/9.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseBettingNumField : UITextField
@property (nonatomic) NSString *defaultText;
- (id)initWithFrame:(CGRect)frame toView:(UIView *)view;

@end
