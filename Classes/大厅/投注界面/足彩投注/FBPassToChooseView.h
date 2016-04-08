//
//  FBPassToChooseView.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/10.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBPassToChooseView : UICollectionView
+ (id)showMenu:(id)datas toView:(UIView *)toView chooseDatas:(NSMutableArray *)chooseDatas select:(void(^)(id datas))select otherEvent:(void(^)())otherEvent;
+ (BOOL)hideHUDForView:(UIView *)view;
+ (void)setInfoText:(NSString *)text toView:(UIView *)toView;
@end
