//
//  BettingHHGGCell.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/8.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BettingHHGGCell.h"

@implementation BettingHHGGCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = Font(14);
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
    NSString *text = [[FootBallModel setHHGGTextWithDatas:model] string];
    CGSize textSize = [NSObject getSizeWithText:text font:_abstracts.font maxSize:CGSizeMake(ScaleW(180), MAXFLOAT)];
    if (textSize.height > ScaleH(25)) {
        abstractsHeight = textSize.height + ScaleH(5);
    }
    
    self.textLabel.frame = CGRectMake(_leagueNameLb.right + ScaleW(10), (self.height - self.textLabel.font.lineHeight - abstractsHeight - ScaleH(5)) / 2, ScaleW(180), self.textLabel.font.lineHeight);
    
    _abstracts.frame = CGRectMake(_leagueNameLb.right + ScaleW(10), CGRectGetMaxY(self.textLabel.frame) + ScaleH(5), CGRectGetWidth(self.textLabel.frame), abstractsHeight);
}

- (void)setDatas:(id)datas
{
    [super setDatas:datas];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ vs %@",_datas[@"host_team"],_datas[@"guest_team"]]];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomBlack range:NSMakeRange([_datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange([_datas[@"host_team"] length], 4)];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, [_datas[@"host_team"] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(attrString.length - [_datas[@"guest_team"] length], [_datas[@"guest_team"] length])];
    self.textLabel.attributedText = attrString;
    
    
    FBDatasModel *model = datas;
    /*修改AbstractsText*/
    _abstracts.attributedText = [FootBallModel setHHGGTextWithDatas:model];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
