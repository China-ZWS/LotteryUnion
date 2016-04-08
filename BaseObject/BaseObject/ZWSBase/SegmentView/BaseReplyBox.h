//
//  BaseReplyBox.h
//  BaseObject
//
//  Created by 周文松 on 15/10/4.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseReplyBox : UIView

+ (BaseReplyBox *)showToSuccess:(void(^)(NSString *string))success;

@end
