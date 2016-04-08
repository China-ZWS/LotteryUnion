//
//  BettingViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/11/1.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BaseBettingViewController.h"
#import "FootBallModel.h"


@interface BackView :UIView

@end
@implementation BackView
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame  ])) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


@end

@interface BaseBettingViewController ()
@end

@implementation BaseBettingViewController

- (id)initWithParameters:(id)parameters
{
    if ((self = [super initWithParameters:parameters])) {
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(willback) image:@"arrow01"];
    }
    return self;
}

- (void)dealloc
{
    [_parameters removeAllObjects];
    [_finished removeFromSuperview];
    [_infoView removeFromSuperview];
}

- (void)willback
{

    if ([_parameters count] > 0)
    {
        [self.view endEditing:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.48 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"退出提示" message:@"返回将清空所有已选的号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [aler show];
            return;
            
        });
        
    }
    [self didBack];
}

- (void)didBack
{
    [self.navigationController  setToolbarHidden:YES animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        [self removeDatas];
        [self didBack];
    }
}

- (void)removeDatas;
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_parameters count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleH(75);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*截止日期*/
    [self.view addSubview:self.titleDate];
    /*继续投注*/
    [self.view addSubview:self.addTitle];
    
    /*设置tableFrame*/
    [self setTableWithFrame: CGRectMake(ScaleW(20), _addTitle.bottom + ScaleH(28), _table.width - ScaleW(40), _table.bottom - ScaleH(85))];
    
    [_table setTableFooterView:[self footerView]];
    [_table addSubview:[self contentView]];

    [self.view addSubview:self.headerImg];
  
    
    [self.navigationController.toolbar addSubview:self.finished];
    [self.navigationController.toolbar addSubview:self.infoView];

    
    [FBTool.formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timestampString = [FBTool.formatter stringFromDate:[NSDate date]];
    [self setEndTime:timestampString];
    [self setSpendfew];

}

- (UIView *)footerView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_table.frame), 80)];
    footerView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_table.frame), 20)];
    UIImage *img = [UIImage imageNamed:@"chupiao_part2.png"];
    CGFloat top = 1; // 顶端盖高度
    CGFloat bottom =  10; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 5; // 右端盖宽度
     UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    img = [img resizableImageWithCapInsets:insets ];
    imageView.image = img;
    [footerView addSubview:imageView];
    return footerView;
}

- (UIView *)contentView
{
    BackView *contentView = [[BackView alloc] initWithFrame:CGRectMake(0, -500, DeviceW - ScaleW(40), 500)];;
    return contentView;
}

- (UIImageView *)headerImg
{
    UIImage *image = [UIImage imageNamed:@"chupiao_part1.png"];
    CGFloat top = 1; // 顶端盖高度
    CGFloat bottom = 1 ; // 底端盖高度
    CGFloat left = 11; // 左端盖宽度
    CGFloat right = 11; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    image = [image resizableImageWithCapInsets:insets ];

    _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_table.frame) - 10, CGRectGetMinY(_table.frame) - ScaleH(18), CGRectGetWidth(_table.frame) + 20, ScaleH(18))];
    _headerImg.image = image;
    return _headerImg;
}

- (UILabel *)titleDate
{

    _titleDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DeviceW, ScaleH(25))];
    _titleDate.font = Font(12);
    _titleDate.textAlignment = NSTextAlignmentCenter;
    return _titleDate;
}

- (UIButton *)addTitle
{
    _addTitle = [ UIButton buttonWithType:UIButtonTypeCustom];
    _addTitle.frame = CGRectMake(0, CGRectGetMaxY(_titleDate.frame), DeviceW, ScaleH(35));
    _addTitle.backgroundColor = [UIColor whiteColor];
    [_addTitle setImage:[UIImage imageNamed:@"jczq_add.png"] forState:UIControlStateNormal];
    _addTitle.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [_addTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _addTitle.titleLabel.font = Font(13);
    [_addTitle setTitle:@"继续选择比赛" forState:UIControlStateNormal];
    [_addTitle addTarget:self action:@selector(eventWithPlayon) forControlEvents:UIControlEventTouchUpInside];
    return _addTitle;
}

#pragma mark - 设置投注按钮
- (UIButton *)finished
{
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    _finished = [UIButton buttonWithType:UIButtonTypeCustom];
    _finished.frame = CGRectMake(DeviceW - ScaleW(15)  - ScaleW(60), (CGRectGetHeight(self.navigationController.toolbar.frame) - ScaleH(30)) / 2, ScaleW(60), ScaleH(30));
    [_finished setTitle:@"投 注" forState:UIControlStateNormal];
    _finished.backgroundColor = CustomRed;
    _finished.titleLabel.font = Font(15);
    [_finished getCornerRadius:5 borderColor:[UIColor clearColor] borderWidth:0 masksToBounds:YES];
    [_finished addTarget:self action:@selector(eventWithFinish) forControlEvents:UIControlEventTouchUpInside];
    return _finished;
}


#pragma mark - 点击完成按钮
- (void)eventWithFinish
{}

#pragma mark - 投注信息
- (UILabel *)infoView
{
    _infoView = [[UILabel alloc] initWithFrame:CGRectMake(ScaleX(15), 0, DeviceW - ScaleW(30)  - ScaleW(60), CGRectGetHeight(self.navigationController.toolbar.frame))];
    _infoView.font = NFont(15);
    _infoView.textColor = [UIColor whiteColor];
    return _infoView;
}


#pragma mark - 设置截止时间
- (void)setEndTime:(NSString *)endTime
{
    NSString *titleDate = [NSString stringWithFormat:@"投注截止时间：%@",endTime];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleDate];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([@"投注截止时间：" length], endTime.length)];
    _titleDate.attributedText = attrString;
}

#pragma mark - 设置已添加几场比赛
- (void)setSpendfew
{
    NSString *title = [NSString stringWithFormat:@"继续选择比赛 已添加%d场",[_parameters count]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:CustomRed range:NSMakeRange([@"继续选择比赛 " length], [[NSString stringWithFormat:@"已添加%d场",[_parameters count]] length])];
    [attrString addAttribute:NSFontAttributeName value:Font(10) range:NSMakeRange([@"继续选择比赛 " length], [[NSString stringWithFormat:@"已添加%d场",[_parameters count]] length])];
    [_addTitle setAttributedTitle:attrString forState:UIControlStateNormal];
}


- (void)setInfoAttributedText:(NSMutableAttributedString *)attrString;
{
    _infoView.attributedText = attrString;
    
}

#pragma mark - 继续投注
- (void)eventWithPlayon
{
    [self popViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController  setToolbarHidden:NO animated:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController  setToolbarHidden:YES animated:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [super viewWillDisappear:animated];
}

#pragma mark - 取消一切编辑事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
        
}


- (void)gotoBetting:(NSString *)period gift_phone:(NSString *)gift_phone greetings:(NSString *)greetings;
{
    
}

@end
