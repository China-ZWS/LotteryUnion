//
//  CustomTextView.h
//  OxygenPerson
//
//  Created by ZhangJC on 14-9-16.
//  Copyright (c) 2014年 pengxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextView : UITextView<UITextViewDelegate>

@property (copy, nonatomic) NSString *placeholder;  //默认填充字符串
@property (strong, nonatomic) UILabel *placeholderLabel; //站位label

@end
