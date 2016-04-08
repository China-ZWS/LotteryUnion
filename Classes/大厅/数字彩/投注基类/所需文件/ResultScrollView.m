//
//  ResultScrollView.m
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "ResultScrollView.h"
#import "BetCartViewController.h"
#import "BetResultCell.h"


#define Cell_Identifier @"Cell_Identifier"

#define Print_text_color [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1]


#pragma mark -- 定制背景视图 -----------------
@interface MyBackView :UIView
@end
@implementation MyBackView
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame  ]))
    {
        
    }
    return self;
}

//TODO:绘制图表
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
    
    [self drawRectWithLine:rect start:CGPointMake(0, 0) end:CGPointMake(0, CGRectGetHeight(rect)) lineColor:CustomBlack lineWidth:LineWidth];
    [self drawRectWithLine:rect start:CGPointMake(CGRectGetWidth(rect), 0) end:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)) lineColor:CustomBlack lineWidth:LineWidth];
}
@end

#pragma mark -- 背景滑动视图 -----------------

@implementation ResultScrollView
{
    UIImageView *_headerImg;  //表盖视图
}
@synthesize betNumber = _betNumber;
@synthesize delegate = _delegate;

//TODO:改变背景的高度
-(void)changeResultHeight:(float)deltaHeight
{
    [self setHeight:self.height+deltaHeight];
    [_resultTable setHeight:self.height-13];
}

//TODO:根据数组实例化
- (id)initWithFrame:(CGRect)frame betArray:(NSMutableArray*)array
{
    if (self = [super initWithFrame:frame])
    {
        // 选好的数组
        betResults = array;
        //创建表
        [self createTableWithFrame:frame];
        
    }
    return self;
}



#pragma mark -- 滑动表视图相关 ----------------------
//TODO:创建表
- (void)createTableWithFrame:(CGRect)frame
{
    _resultTable = [[UITableView alloc] initWithFrame:CGRectZero];
    _resultTable.frame = CGRectMake(0,10, frame.size.width, frame.size.height);
    if (iOS7)
    {
        _resultTable.tableHeaderView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, _resultTable.bounds.size.width, 0.01)];
    }
    _resultTable.backgroundColor = [UIColor clearColor];
    [_resultTable setShowsVerticalScrollIndicator:NO];
    [_resultTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_resultTable setBackgroundView:nil];
    _resultTable.delegate = self;
    _resultTable.dataSource = self;
    [_resultTable setBounces:YES];
    
    [_resultTable setTableFooterView:[self footerView]];
    [_resultTable addSubview:[self contentView]];
    
    [self addSubview:self.headerImg];
    [self addSubview:_resultTable];


}
//TODO:表尾视图
- (UIView *)footerView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_resultTable.frame), 50)];
    footerView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_resultTable.frame), 20)];
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
//TODO:内容视图
- (UIView *)contentView
{
    MyBackView *contentView = [[MyBackView alloc] initWithFrame:CGRectMake(0, -500, self.width, 500)];;
    return contentView;
}

//TODO:顶部图像
- (UIImageView *)headerImg
{
    UIImage *image = [UIImage imageNamed:@"chupiao_part1.png"];
    CGFloat top = 1; // 顶端盖高度
    CGFloat bottom = 1 ; // 底端盖高度
    CGFloat left = 11; // 左端盖宽度
    CGFloat right = 11; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    image = [image resizableImageWithCapInsets:insets];
    
    _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_resultTable.frame) - 10, CGRectGetMinY(_resultTable.frame) - ScaleH(18), CGRectGetWidth(_resultTable.frame) + 20, ScaleH(18))];
    _headerImg.image = image;
    return _headerImg;
}

#pragma --mark UITableViewDelegate -----------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //结果数组
    NSArray *tArray = [BetResultCell parseBetNumbers:[betResults objectAtIndex:indexPath.row]];
    UIFont *mFont = [UIFont systemFontOfSize:15];
    
    NSString *mText = nil;
    // tArray（只有在大乐透中又两个元素，其他彩种都只有一个元素）
    if ([tArray count] == 1)
    {
        mText = tArray[0];
    }
    else
    {
        mText = [tArray[0] stringByAppendingString:tArray[1]];
    }
    
   CGSize size =  [mText  boundingRectWithSize:CGSizeMake(mScreenWidth-150, 300) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:mFont} context:nil].size;
    
    return size.height+50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return betResults.count;
}

#pragma mark 每一行cell怎么显示
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BetResultCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Identifier];
    NSInteger cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[BetResultCell alloc] initWithFrame:CGRectMake(0,0,mScreenWidth-10,0) reusedIdentifier:Cell_Identifier];
    }
    
    [cell setHeight:cellHeight];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // 将选好号的数据传给cell
    
    [cell setBetResult:[betResults objectAtIndex:indexPath.row]];
    
    [cell.delResult setTag:indexPath.row];
    
    //删除按钮
    [cell.delResult addTarget:self action:@selector(removeBetResultAtPosition:)
             forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark -- 添加或删除一注的方法 ------------------------
//TODO:添加一注机选选号
-(void)insertBetResult:(id)betResult atPositon:(int)pos
{
    if(pos>-1 && pos<=betResults.count)
    {
        [betResults insertObject:betResult atIndex:pos];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSIndexPath indexPathForRow:pos inSection:0]];
        
        // 选号的插入
        [_resultTable insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [self delayToReloadTable];
    }

}

//TODO:删除一注投注结果
-(void)removeBetResultAtPosition:(id)sender
{
    int pos = (int)[sender tag];
    if(pos>-1 && pos<betResults.count)
    {
        [betResults removeObjectAtIndex:pos];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSIndexPath indexPathForRow:pos inSection:0]];
        [_resultTable deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [self delayToReloadTable];
    }
}

//延时执行加载重新加载Table的数字
-(void)delayToReloadTable
{
    dispatch_async(dispatch_queue_create(0, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        [self performSelectorOnMainThread:@selector(reloadVisibleTableData)
                               withObject:nil waitUntilDone:NO];
    });
}

//TODO:重新加载数据
-(void)reloadVisibleTableData
{
    [_resultTable reloadRowsAtIndexPaths:[_resultTable indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    
    if([_delegate respondsToSelector:@selector(resultChanged)])
    {
       [_delegate resultChanged];
    }
    
}

//TODO:加载数据
-(void)reloadTableData
{
    
    [_resultTable reloadData];
    
    if([_delegate respondsToSelector:@selector(resultChanged)])
    {
       [_delegate resultChanged];
    }
    
}

@end