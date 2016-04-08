//
//  DropdownMenu.h
//  LotteryUnion
//
//  Created by 周文松 on 15/10/24.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdownMenu : UIView
+ (id)showMenu:(NSArray *)datas toView:(UIView *)toView index:(NSInteger)index select:(void(^)(id datas))select otherEvent:(void(^)())otherEvent;
+ (BOOL)hideHUDForView:(UIView *)view;

@end
