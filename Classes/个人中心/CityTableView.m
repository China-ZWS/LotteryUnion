//
//  CityTableView.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/19.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "CityTableView.h"


@interface ChooseCell : UITableViewCell

@property(nonatomic,strong)UIImageView * chooseButton;//是否选中的按钮

@end

@implementation ChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self _initUI];
    }
    return self;
}
//TODO:填加按钮
- (void)_initUI
{

    _chooseButton = [[UIImageView alloc]initWithFrame:mRectMake(mScreenWidth-30-20, 10, 15, 15)];
    _chooseButton.image = [UIImage imageNamed:@"czzz_circle.png"] ;
    
    [self.contentView addSubview:_chooseButton];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if(selected == YES)
    {
       _chooseButton.image = [UIImage imageNamed:@"czzz_circle_red.png"] ;
        
    }else{
    
       _chooseButton.image = [UIImage imageNamed:@"czzz_circle.png"] ;
    }
}

@end

@implementation CityTableView
{
    UIImageView *redIcon;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.bankIDArray = [NSMutableArray new];
        self.bankNameArray = [NSMutableArray new];
        self.allowsMultipleSelection = NO;
        [self loadData];
    }
    
    return self;
}

//获取数据
- (void)loadData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"RecordItem.plist" ofType:nil];
    NSArray *d = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *dic in d) {
        NSString *bankId =  dic[@"bankID"];
        NSString *bankName = dic[@"bankName"];
        
        [self.bankIDArray addObject:bankId];
        [self.bankNameArray addObject:bankName];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseCell *cell = [[ChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_identify"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderColor = [[UIColor redColor] CGColor];
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"其他";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        cell.textLabel.text = self.bankNameArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    if([cell.textLabel.text isEqualToString:_fromBankName])
    {
        redIcon = [[UIImageView alloc]initWithFrame:mRectMake(mScreenWidth-30-20, 10, 15, 15)];
        redIcon.image =  [UIImage imageNamed:@"czzz_circle_red.png"];
        [cell.contentView addSubview:redIcon];
      
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    ChooseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [redIcon  removeFromSuperview];
    _fromBankName = cell.textLabel.text;
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self
                                                       userInfo:@{@"name":self.bankNameArray[indexPath.row],
                                                                  @"bankID":self.bankIDArray[indexPath.row]}];
}






@end
