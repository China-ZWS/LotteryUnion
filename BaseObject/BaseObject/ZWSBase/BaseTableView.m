//
//  BaseTableView.m
//  BabyStory
//
//  Created by 周文松 on 14-11-6.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import "BaseTableView.h"
#import "Category.h"
#import "Device.h"
#import "Header.h"

@implementation BaseTableView





- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
   
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(BaseTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(touchesBegan:withEvent:)])
    {
        [_touchDelegate  touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(BaseTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(touchesCancelled:withEvent:)])
    {
        [_touchDelegate touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(BaseTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(touchesEnded:withEvent:)])
    {
        [_touchDelegate touchesEnded:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(BaseTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(touchesMoved:withEvent:)])
    {
        [_touchDelegate touchesMoved:touches withEvent:event];
    }
}

- (void)setDatas:(id)datas
{
    _datas = datas;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
