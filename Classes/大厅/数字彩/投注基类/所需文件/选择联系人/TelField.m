//
//  TelField.m
//  YaBoCaiPiaoFJ
//
//  Created by jamalping on 14-4-1.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import "TelField.h"

@implementation TelField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

// 按确定时的代理方法自动切换响应者
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self textFieldShouldReturn:textField];
}


@end
