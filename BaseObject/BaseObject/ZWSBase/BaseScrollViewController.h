//
//  BaseScrollViewController.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-11.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseScrollView.h"
@interface BaseScrollViewController : BaseViewController
{
    BaseScrollView *_scrollView;
}
@property (nonatomic, strong) BaseScrollView *scrollView;

@end
