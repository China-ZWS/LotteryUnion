//
//  HHGGOptionView.h
//  LotteryUnion
//
//  Created by 周文松 on 15/11/5.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FootBallModel.h"

@interface HHGGOptionView : UIView
+ (id)showWithDatas:(id)datas cacheModel:(FBDatasModel *)cacheModel finished:(void(^)(FBDatasModel *model))finished;

@end
