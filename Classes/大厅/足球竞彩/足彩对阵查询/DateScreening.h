//
//  DateScreening.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateScreening : UIView
+ (id)showWithResult:(void(^)(NSString *dateString))result;

@end
