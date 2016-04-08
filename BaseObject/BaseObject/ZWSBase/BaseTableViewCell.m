//
//  BaseTableViewCell.m
//  MoodMovie
//
//  Created by 周文松 on 14-7-30.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    
}

- (void)setDatas:(id)datas
{
    _datas = datas;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
