//
//  LabelButton.h
//  YaBoCaiPiaoFJ2
//
//  Created by jamalping on 14-6-9.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelButton : UIButton

@property(nonatomic)id aTargert;
@property(nonatomic)SEL selectAction;

@property (nonatomic,copy)UIImage *highlightImage; //高亮
@property (nonatomic,copy)UIImage *normalImage;    //正常
@property (nonatomic,copy)UIImage *selectImage;    //选中
//@property (nonatomic,strong)UIImageView *imageView; // 背景颜色视图

+ (id)initWithFrame:(CGRect)frame addTarger:(id)aTarger selection:(SEL)selection atag:(int)tag logViewStr:(NSString *)imgStr labelText:(NSString *)text normalImgStr:(NSString *)normalImgStr selectImgStr:(NSString *)selectImgStr;

@end
