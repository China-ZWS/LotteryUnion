//
//  SideSegmentControllerDataSource.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-30.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//


@protocol SideSegmentControllerDataSource <NSObject>
@required

- (NSInteger)slideSegment:(UICollectionView *)segmentBar
   numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)slideSegment:(UICollectionView *)segmentBar
                cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInslideSegment:(UICollectionView *)segmentBar;
@end
