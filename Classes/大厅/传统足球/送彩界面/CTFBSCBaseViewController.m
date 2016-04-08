
//
//  CTFBSCBaseViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/18.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CTFBSCBaseViewController.h"
#import "CTFBModel.h"
#import "CTFBSCToolView.h"
#import "BaseBettingModel.h"

@interface CTFBSCBaseViewController ()
{
    CTFBSCToolView *_toolView;
}
@end

@implementation CTFBSCBaseViewController




- (id)init
{
    if ((self = [super init])) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}



- (UIButton *)addTitle
{
    _addTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    _addTitle.frame = CGRectMake(0, ScaleY(10), DeviceW, ScaleH(35));
    _addTitle.backgroundColor = [UIColor whiteColor];
    [_addTitle setImage:[UIImage imageNamed:@"jczq_add.png"] forState:UIControlStateNormal];
    _addTitle.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [_addTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _addTitle.titleLabel.font = Font(13);
    [_addTitle setTitle:@"多送一注" forState:UIControlStateNormal];
    [_addTitle addTarget:self action:@selector(eventWithPlayon) forControlEvents:UIControlEventTouchUpInside];
    return _addTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.height -= ScaleH(20);
    [_finished setTitle:@"送彩票" forState:UIControlStateNormal];
}

- (void)initToolBar
{
    CTFBTool.multiple  = 1;
    _toolView = [[CTFBSCToolView  alloc] initWithFrame:CGRectMake(0, DeviceH - 132, DeviceW, 88) success:^{
        
    }];
    [self.view addSubview:_toolView];
}

- (void)gotoBetting:(NSString *)period gift_phone:(NSString *)gift_phone greetings:(NSString *)greetings
{
    
    BOOL isPhoneNum = [NSObject isMobileNumber:_toolView.phoneNum.text];
    NSUInteger doc = [_toolView.phoneNum.text length];
    
    if (!doc || !isPhoneNum) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    [super gotoBetting:period gift_phone:_toolView.phoneNum.text greetings:_toolView.leaveWord.text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
