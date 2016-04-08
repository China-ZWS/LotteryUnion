//
//  BaseTableViewCell.h
//  MoodMovie
//
//  Created by 周文松 on 14-7-30.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell
{
    UIImageView *_headImageView;
    UILabel *_title;
    UILabel *_abstracts;
    UILabel *_name;
    UILabel *_createTime;
    UILabel *_textLb;
    UILabel *_contentLb;
    id _datas;
    UICollectionView *_collectionView;
}
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel *abstracts;
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic,assign) NSDictionary *dic;
@property (nonatomic, strong) UILabel *textLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) id datas;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
