//
//  LabelButton.m
//  YaBoCaiPiaoFJ2
//
//  Created by jamalping on 14-6-9.
//  Copyright (c) 2014年 DoMobile. All rights reserved.
//

#import "LabelButton.h"

@implementation LabelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

// 类方法创建 选择按钮（参数frame，title，图标字符串,正常的背景字符串，选中的背景字符串）
+ (id)initWithFrame:(CGRect)frame addTarger:(id)aTarger selection:(SEL)selection atag:(int)tag logViewStr:(NSString *)imgStr labelText:(NSString *)text normalImgStr:(NSString *)normalImgStr selectImgStr:(NSString *)selectImgStr
{
    //
    LabelButton *button = [LabelButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setBackgroundImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImgStr] forState:UIControlStateSelected];
//    [button setImage:[UIImage imageNamed:selectImgStr] forState:UIControlStateSelected];
    [button addTarget:aTarger action:selection forControlEvents:UIControlEventTouchUpInside];
    
    // 图标
    UIImage *img = [UIImage imageNamed:imgStr];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:img];
    logoView.frame = CGRectMake((frame.size.width-img.size.width)/2, 20, img.size.width, img.size.height);

    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.origin.x, logoView.frame.origin.y +logoView.frame.size.height, 100, 30)];
    titleLabel.text = text;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [titleLabel sizeToFit];
    
//    [button addSubview:logoView];
//    [button addSubview:titleLabel];
    
    return button;
}

@end
