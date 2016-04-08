//
//  Message.m
//  LotteryUnion
//
//  Created by xhd945 on 15/10/19.
//  Copyright © 2015年 xhd945. All rights reserved.
//

#import "MessageVC.h"

@interface MessageVC ()

@end

@implementation MessageVC
- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"活 动"];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [SVProgressHUD showInfoWithStatus:@"暂无活动~"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImageView *image = [[UIImageView alloc]initWithFrame:mRectMake(0, 0, mScreenWidth*0.5, mScreenHeight*0.3)];
    image.image = mImageByName(@"nomes");
    image.center = CGPointMake(mScreenWidth/2.0, (mScreenHeight-64-49)/2.0-20);
    [self.view addSubview:image];
}


//TODO:设置背景图片
- (void)addBackgroundImageWithImageName:(NSString*)imgName
{
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:mRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgImageView.image = mImageByName(imgName);
    [self.view addSubview:bgImageView];


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
