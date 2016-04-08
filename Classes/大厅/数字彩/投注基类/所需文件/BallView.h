//
//  ballView.h
//  YaBoCaiPiaoSDK
//
//  Created by jamalping on 14-6-5.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallView : UIView
{
    UIWindow *_magnifierView; // 放大镜视图
    UIView *bbb;
}

@property (nonatomic,copy)NSString *number;// 放大镜上显示的球的号码
@property (nonatomic,copy)UIImage *highlightImage;
@property (nonatomic,copy)UIImage *normalImage;
@property (nonatomic,copy)UIImage *selectImage;
@property (nonatomic)SEL action; //小球的响应方法
@property (nonatomic,weak)id Target;  //小球的响应方法
@property (nonatomic,strong)UIImageView *imageView; // 背景颜色视图
@property (nonatomic,strong)UILabel *label;         // 数字
@property (nonatomic)BOOL selected;
@property (nonatomic)BOOL small;
@property (nonatomic)BOOL isRedBall; //是否是红球
@property (nonatomic)NSArray *selectArray;


// 类方法创建球视图
/*
 *
 *
 */
+(BallView *)ballViewWithFrame:(CGRect)frame target:(id)aTarget action:(SEL)action tag:(int)aTag normalTitle:(NSString *)nTitle normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage selectImage:(UIImage *)selectImage selectArray:(NSArray *)selectArray magnifierImage:(UIImage *)bgImg isSmall:(BOOL)small;

// 是否选中的UI变化
-(void)isSelectedWithChange;

@end