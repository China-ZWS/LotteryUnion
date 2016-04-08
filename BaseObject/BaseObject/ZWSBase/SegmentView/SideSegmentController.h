//
//  SideSegmentController.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-30.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "SideSegmentControllerDelegate.h"
#import "SideSegmentControllerDataSource.h"
#import <UIKit/UIKit.h>

@interface SideSegmentController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, strong, readonly) UICollectionView *segmentBar;
@property (nonatomic, strong, readonly) UIScrollView *slideView;
@property (nonatomic, strong, readonly) UIView *indicator;

@property (nonatomic, assign) UIEdgeInsets indicatorInsets;

@property (nonatomic, weak, readonly) UIViewController *selectedViewController;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;



/**
 *  By default segmentBar use viewController's title for segment's button title
 *  You should implement JYSlideSegmentDataSource & JYSlideSegmentDelegate instead of segmentBar delegate & datasource
 */
@property (nonatomic, assign) id <SideSegmentControllerDelegate> delegate;
@property (nonatomic, assign) id <SideSegmentControllerDataSource> dataSource;
@property (nonatomic) UIColor *backgroudColor;
@property (nonatomic) UIColor *lineColor;
@property (nonatomic) CGRect segmentBarFrame;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIColor *selectedTitleColor;
- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;
@end




