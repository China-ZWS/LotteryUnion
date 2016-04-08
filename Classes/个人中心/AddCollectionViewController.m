//
//  AddCollectionViewController.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/8.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AddCollectionViewController.h"
#import "ProjectAPI.h"
#import "RTLabel.h"
#import "XHDHelper.h"

@interface AddCollectionViewController () {
    UITableView *_tableView;
    UITextField *textDesc;
    NSString *_selectNumber;
    NSString *_lotteryName;
    UITextView *textDescView;
    UIButton *loginbutton;
    UIScrollView *_scrollView;
}

@end

@implementation AddCollectionViewController


- (instancetype)initWithWinModel:(WinModel *)winModel WithSelectNumber:(NSString *)selectNumber{
    if (self = [super init]) {
        self.winModel = winModel;
        _selectNumber = selectNumber;
        
        NSLog(@"%@",selectNumber);
        
         self.title = @"收藏号码";
         self.data = [NSMutableArray new];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
    }
    
    return self;
}

- (instancetype)initWithWinModel:(WinModel *)winModel WithLotteryName:(NSString *)lotteryName WithSelectNumber:(NSString *)selectNumbe {
    
    if (self = [super init]) {
        self.winModel = winModel;
        _lotteryName = lotteryName;
        _selectNumber = selectNumbe;
        
        NSLog(@"_selectNumber = %@",_selectNumber);
        
        self.title = @"收藏号码";
        self.data = [NSMutableArray new];
        [self.navigationItem setBackItemWithTarget:self title:nil action:@selector(back) image:@"arrow01"];
    }
    
    return self;
}


//TODO:返回动作
- (void)back
{
    [self popViewController];
     [SVProgressHUD dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, -20, mScreenWidth-20, mScreenHeight-64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth-20, mScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.userInteractionEnabled = YES;
    [_scrollView addSubview:_tableView];
    

    
    textDescView = [[UITextView alloc] initWithFrame:CGRectMake(60.0,7,mScreenWidth-90,50)];
    textDescView.editable = YES;
    textDescView.backgroundColor = [UIColor clearColor];
    [XHDHelper addToolBarOnInputFiled:textDescView Action:@selector(cancleFirst:) Target:self];
    textDescView.delegate = self;
    
    
    
    loginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginbutton.frame = CGRectMake(15,15,(mScreenWidth-35),35);
    loginbutton.backgroundColor = RGBA(196, 42, 37, 1);
    [loginbutton setTitle:LocStr(@"提交") forState:UIControlStateNormal];
    [loginbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginbutton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.contentSize.height <=30) {
        textDescView.height = 35;
    }else {
        textDescView.height =  [self calcFormatedAddDescHeight]-20;
        NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
        [textDescView becomeFirstResponder];
    }
    NSLog(@"textDescView.height = %f",textDescView.height);
    
}

// 这里限制了一下textView的文本长度
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if([newString length] > 100)
    {
        return NO;
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (iPhone4) {
        if (textView == textDescView) {
            [UIView animateWithDuration:0.3 animations:^{
                _scrollView.contentOffset = CGPointMake(0, 90);
            }];
        }
    }
}

#pragma mark -  UITableView  delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0)
    {
        NSString *playType = getPlayTypeName([[self.winModel lottery_code] intValue]);
        cell.textLabel.text = [NSString stringWithFormat:@"%@:    %@  %@",LocStr(@"彩种"),_lotteryName,playType];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    else if (indexPath.row == 1)
    {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",LocStr(@"号码"),_selectNumber];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 60, 30)];
        textLabel.text = @"号码：";
        textLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:textLabel];
        
        RTLabel *label = [self makeRTLabel];
        label.text = _selectNumber;
        label.font = [UIFont systemFontOfSize:13];
        [cell addSubview:label];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        
    }else if (indexPath.row == 2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: ",LocStr(@"备注")];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:textDescView];
        
    }
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 20, mScreenWidth-30, 100)];
    loginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginbutton.frame = CGRectMake(15,15,(mScreenWidth-50),35);
    loginbutton.backgroundColor = RGBA(196, 42, 37, 1);
    [loginbutton setTitle:LocStr(@"提交") forState:UIControlStateNormal];
    [loginbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginbutton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    view.userInteractionEnabled = YES;
    [view addSubview:loginbutton];
    return view;
}

//设置段尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}


#pragma mark - 提交收藏网络请求
- (void)submitAction {
    
    NSLog(@"提交");
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain: kAPI_BookmarkAdd];
    params[@"lottery_pk"] = self.winModel.lottery_pk;
    params[@"lottery_code"] = self.winModel.lottery_code;
    params[@"number"] = self.winModel.number;
    params[@"desc"] = textDescView.text?textDescView.text:@"";
    
    NSLog(@"%ld",(long)kAPI_BookmarkAdd);
    
    _connection = [RequestModel POST:URL(kAPI_BookmarkAdd) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   
                   {
                       NSLog(@"data = %@",data);
                       //[_tableView reloadData];
                       [self.navigationController popViewControllerAnimated:YES];
                       [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       if ([state integerValue] == Status_Code_User_Not_Login)
                       {
                           [super gotoLoging];
                           [SVProgressHUD dismiss];
                           return;
                       }
                       [SVProgressHUD showErrorWithStatus:@"收藏失败"];
                       
                   }];
}

- (void)refreshWithViews
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        return  [self calcFormatedNumberHeight];
    }else if(indexPath.section == 0 && indexPath.row == 2){
        if (textDescView.contentSize.height <= 40) {
            return 45;
        }else {
            return [self calcFormatedAddDescHeight];
            
        }
    }else {
        return 45;
    }
}


-(RTLabel*)makeRTLabel{
    RTLabel *label = [[RTLabel alloc] initWithFrame:
                      CGRectMake(60,7+3+2,mScreenWidth,850)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.lineSpacing = 0;
    return label;
}


-(float)calcFormatedNumberHeight
{
    CGFloat hh = [_selectNumber sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(mScreenWidth-20,800)].height;
    NSLog(@"height = %lf",hh);
    return MAX(hh+20, 45);
}


- (float)calcFormatedAddDescHeight {
    int hh = [NSObject getSizeWithText:textDescView.text font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(mScreenWidth-60, 800)].height;
    NSLog(@"height = %d",hh);
    return MAX(hh+30, 45);
}


// 添加单击手势隐藏键盘
-(void)cancleFirst:(UITapGestureRecognizer *)singleTap
{
    if ([textDescView isFirstResponder])
    {
        [textDescView resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            
            _scrollView.contentOffset = CGPointMake(0, 0);
            
        }];
        return;
    }
    
    
}



@end
