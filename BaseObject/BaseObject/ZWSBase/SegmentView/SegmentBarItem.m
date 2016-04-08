//
//  SegmentBarItem.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-30.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "SegmentBarItem.h"
#import "Device.h"

@implementation SegmentBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _titleLabel.font = FontBold(15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
