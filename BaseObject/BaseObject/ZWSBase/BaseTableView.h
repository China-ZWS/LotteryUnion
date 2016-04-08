//
//  BaseTableView.h
//  BabyStory
//
//  Created by 周文松 on 14-11-6.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewDelegate;

@interface BaseTableView : UITableView
{
    id _datas;
}
@property (nonatomic,assign) id<BaseTableViewDelegate> touchDelegate;

@property (nonatomic,strong) id datas;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
@end


@protocol BaseTableViewDelegate <NSObject>

@optional
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;




@end