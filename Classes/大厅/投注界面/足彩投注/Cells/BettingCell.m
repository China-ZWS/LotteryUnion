//
//  BettingCell.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/1.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BettingCell.h"
#import "FootBallModel.h"
@interface BettingCell()

@end

@implementation BettingCell

- (void)drawRect:(CGRect)rect
{
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);

//    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(0, CGRectGetHeight(rect)) lineColor:CustomBlack lineWidth:LineWidth];
//    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect), 0) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)) lineColor:CustomBlack lineWidth:LineWidth];
    UIImage *line = [UIImage imageNamed:@"chupiao_xuxian2.png"];
    [line drawInRect:CGRectMake(ScaleW(10), CGRectGetHeight(rect) - line.size.height, CGRectGetWidth(rect) - ScaleW(20), line.size.height)];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor clearColor];
        _leagueNameLb.font = Font(11);
        _positionLb.font = Font(11);
        _endTimeLb.font = Font(9);

        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setImage:[UIImage imageNamed:@"jczq_cut.png"] forState:UIControlStateNormal];
       
        
//        [self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        [self.contentView addSubview:_cancel];
    }
    return self;
}



- (void)layoutSubviews
{
    
    [super layoutSubviews];

    CGSize size = [NSObject getSizeWithText:_leagueNameLb.text font:_leagueNameLb.font maxSize:CGSizeMake(ScaleW(45), MAXFLOAT)];
    
    CGFloat height = 0;
    if (size.height <= ScaleH(15))
    {
        height = ScaleH(15);
        _leagueNameLb.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        height = size.height + 3;
        _leagueNameLb.textAlignment = NSTextAlignmentLeft;
    }
    _leagueNameLb.frame = CGRectMake(ScaleW(10), CGRectGetHeight(self.frame) / 2 - height / 2, ScaleW(45), height);
    
    _positionLb.frame = CGRectMake(CGRectGetMinX(_leagueNameLb.frame), CGRectGetMinY(_leagueNameLb.frame) - ScaleH(2) - ScaleH(15), CGRectGetWidth(_leagueNameLb.frame), ScaleH(15));
    _endTimeLb.frame = CGRectMake(CGRectGetMinX(_leagueNameLb.frame), CGRectGetMaxY(_leagueNameLb.frame) +  ScaleH(3), CGRectGetWidth(_leagueNameLb.frame), ScaleH(15));

    _cancel.frame = CGRectMake(CGRectGetWidth(self.frame) - ScaleW(30), 0, ScaleW(25), CGRectGetHeight(self.frame));
}

- (void)setDatas:(id)datas;
{
    FBDatasModel *model = datas;
    NSDictionary *dic = model.datas;
    [super setDatas:dic];
}

@end
