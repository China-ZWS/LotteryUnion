//
//  ArrowView.h
//  HCTProject
//
//  Created by 周文松 on 14-6-24.
//  Copyright (c) 2014年 com.talkweb.www.HCTProject. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageMode) {
    kLeft = 0, // 胜负平
    kRight, // 让球胜负平

};


@interface ArrowView : UIButton
+(instancetype)buttonInstance;
+(instancetype)buttonInstance:(ImageMode)imageMode;

@end
