//
//  ResultScrollView.h
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorLabel.h"//-
#import "NSString+NumberSplit.h"//-
#import "AttributeColorLabel.h"//-
#import "BetResult.h"   //-
#import "AttributedLabel.h"//-

@interface ResultScrollView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    @private
    
    UITableView *_resultTable;
    UIImageView *bgView;  //背景图
    UIImageView *juchi_bg; //锯齿图
    
    AttributeColorLabel *colorLabel; //属性Label

    NSMutableArray *betResults;       // 存放订单的数组
}

//TODO:初始化的方法
- (id)initWithFrame:(CGRect)frame betArray:(NSMutableArray *)array;

//刷新数据
- (void)reloadTableData;
//改变高度
-(void)changeResultHeight:(float)deltaHeight;
//根据位置插入一注
-(void)insertBetResult:(id)betResult atPositon:(int)pos;

@property (nonatomic) NSString *betNumber; //请求数
@property (nonatomic,weak) id delegate;

@end
