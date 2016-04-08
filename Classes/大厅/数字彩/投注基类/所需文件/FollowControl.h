//
//  FollowControl.h
//  ydtctz
//
//  Created by 小宝 on 1/19/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowControl : UIControl

@property (nonatomic,readonly) BOOL isChoose; //是否选中

- (id)initWithFrame:(CGRect)_frame title:(NSString *)title aDefaultOn:(BOOL)isChoose;

@end
