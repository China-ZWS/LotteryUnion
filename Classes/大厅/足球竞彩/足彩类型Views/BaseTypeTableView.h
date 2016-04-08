//
//  BaseTypeTableView.h
//  LotteryUnion
//
//  Created by 周文松 on 15/10/25.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "PJTableView.h"
#import "FTHelp.h"
#import "FootBallModel.h"
@interface BaseTypeCell : PJTableViewCell
{
    UILabel *_positionLb;
    UILabel *_leagueNameLb;
    UILabel *_endTimeLb;

}
@property (nonatomic, strong) UILabel *positionLb;
@property (nonatomic, strong) UILabel *leagueNameLb;
@property (nonatomic, strong) UILabel *endTimeLb;
@end

@interface BaseTypeTableView : PJTableView
<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_singleDatas;
    /**
     *  @brief 过关重组的数据
     */
    NSArray *_skipmatchDatas;
    
}

- (void)setDatas:(id)datas bettingType:(FBBettingType)bettingType keyword:(NSString *)keyword predicateWithFormats:(NSArray *)predicateWithFormats;
- (void)setDatas:(id)datas bettingType:(FBBettingType)bettingType;
@end
