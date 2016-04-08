//
//  HelpContentViewController.h
//  ydtctz
//
//  Created by 小宝 on 1/7/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "PJViewController.h"


@interface HelpContentViewController : PJViewController<UIWebViewDelegate,UIAlertViewDelegate>
{
    UIWebView *_contentView;
    NSString *_content;
    NSString *_code;
    
}
@property(nonatomic,strong)NSString*navTitle; //标题
- (id)initWithContent:(NSString *)content;
- (id)initWithHTMLCode:(NSString *)code;

@property (nonatomic) BOOL isModalView;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *htmlTag;

@end
