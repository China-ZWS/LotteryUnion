//
//  BettingBQCCell.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/3.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BettingBQCCell.h"
#import "PJCollectionViewCell.h"

@interface BettingBQCCollectCeLL : PJTableViewCell

@end
@implementation BettingBQCCollectCeLL



@end


@interface BettingBQCCell ()

@end
@implementation BettingBQCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        [self.contentView addSubview:_title];
        _abstracts = [UILabel new];
        _abstracts.font = Font(14);
        _abstracts.numberOfLines = 0;
        _abstracts.textAlignment = NSTextAlignmentCenter;
        _abstracts.backgroundColor = RGBA(240, 244, 235, 1);
        [_abstracts getCornerRadius:0 borderColor:RGBA(223, 223, 223, 1) borderWidth:1 masksToBounds:YES];
        _abstracts.textColor = CustomBlack;
        [self.contentView addSubview:_abstracts];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat abstractsHeight = ScaleH(25);
    
    FBDatasModel *model = [FootBallModel filtrateWithBettingDatas:_datas];
    NSString *text = [[FootBallModel setBQCTextWithDatas:model.BQCDatas] string];
    CGSize textSize = [NSObject getSizeWithText:text font:_abstracts.font maxSize:CGSizeMake(ScaleW(180), MAXFLOAT)];
    if (textSize.height > ScaleH(25)) {
        abstractsHeight = textSize.height + ScaleH(5);
    }
    
    _title.frame = CGRectMake(_leagueNameLb.right + ScaleW(10), (self.height - _title.font.lineHeight - abstractsHeight - ScaleH(5)) / 2, ScaleW(180), _title.font.lineHeight);
    
    _abstracts.frame = CGRectMake(_leagueNameLb.right + ScaleW(10), CGRectGetMaxY(_title.frame) + ScaleH(5), CGRectGetWidth(_title.frame), abstractsHeight);
}


- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ vs %@",_datas[@"host_team"],_datas[@"guest_team"]]];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([_datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([_datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, [_datas[@"host_team"] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(attrString.length - [_datas[@"guest_team"] length], [_datas[@"guest_team"] length])];
    _title.attributedText = attrString;
    
    
    FBDatasModel *model = datas;
    /*修改AbstractsText*/
    _abstracts.attributedText = [FootBallModel setBQCTextWithDatas:model.BQCDatas];
}






@end
