//
//  BannerView.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-3-19.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerView : UIScrollView
{
    void(^_select)(id data);
}

@property (nonatomic,strong) NSArray *data;
- (id)initWithSelect:(void(^)(id data))select;
@property (nonatomic) BOOL isStop;
@end
