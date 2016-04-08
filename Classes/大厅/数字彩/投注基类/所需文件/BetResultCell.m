//
//  ResultCell.m
//  LotteryUnion
//
//  Created by xhd945 on 15/11/17.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "BetResultCell.h"
#import "BetResult.h"
#import "AttributeColorLabel.h"
#import "NSString+NumberSplit.h"


#define sepColor   [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.9]

@implementation BetResultCell
{
    UIImageView *imageView1;
}

@synthesize delResult;
@synthesize numberLabel,playLabel,moneyLabel,sepLine;


-(void)drawRect:(CGRect)rect
{
    
#if 0
    
    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.contentView.height-2.0, self.contentView.width-20, 1.5)];
    
    [self.contentView addSubview:imageView1];
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
   [imageView1.image drawInRect:CGRectMake(0, -2, imageView1.frame.size.width, imageView1.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    //设置线条终点形状
    CGFloat lengths[] = {1,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line, imageView1.width, 2.0);
    CGContextStrokePath(line);
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
#endif
    
}

//TODO:备注：cell左右有15空白
-(id)initWithFrame:(CGRect)frame reusedIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];
    if(self) {
        
    
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor clearColor]];
        UIImage *bgImage = [UIImage imageNamed:@"bet_result_cell_ss"];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
        [self setBackgroundView:bgView];
        
        // 删除按钮
        CGRect cFrame = CGRectMake(self.frame.size.width-70,(self.frame.size.height-40)/2.0,40,40);
        delResult = [[UIButton alloc] initWithFrame:cFrame];
        [delResult setShowsTouchWhenHighlighted:YES];
        UIImageView *delImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jczq_cut"]];
        [delImage setFrame:CGRectMake(0,0,17,17)];
        [delImage setCenter:CGPointMake(delResult.width/2, delResult.height/2)];
        [delResult addSubview:delImage];
        
        // 投注号码
        cFrame = CGRectMake(36,0,self.width-100,self.height-20);
        numberLabel = [[UILabel alloc] initWithFrame:cFrame];
        [numberLabel setNumberOfLines:0];
        [numberLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [numberLabel setTextColor:REDFONTCOLOR];
        [numberLabel setFont:[UIFont systemFontOfSize:15]];
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        
        // 玩法
        cFrame = CGRectMake(cFrame.origin.x,self.height-20,0,20);
        playLabel  = [[UILabel alloc] initWithFrame:cFrame];
        [playLabel setNumberOfLines:1];
        [playLabel setTextColor:NAVITITLECOLOR];
        [playLabel setFont:[UIFont systemFontOfSize:14]];
        [playLabel setBackgroundColor:[UIColor clearColor]];
        
        // 金额
        cFrame = CGRectMake(0,self.height-20,0,20);
        moneyLabel  = [[UILabel alloc] initWithFrame:cFrame];
        [moneyLabel setNumberOfLines:1];
        [moneyLabel setTextColor:NAVITITLECOLOR];
        [moneyLabel setFont:[UIFont systemFontOfSize:14]];
        [moneyLabel setBackgroundColor:[UIColor clearColor]];
        
        //虚线
        cFrame = CGRectMake(15,0,self.width-60,0.5);
        sepLine = [[UIImageView alloc] initWithFrame:cFrame];
        [sepLine setImage:[UIImage imageNamed:@"chupiao_xuxian2"]];
        
        [self addSubview:delResult];    // 删除按钮
        [self addSubview:numberLabel];  // 投注号码
        [self addSubview:playLabel];    // 玩法按钮
        [self addSubview:moneyLabel];   // 金额
        [self addSubview:sepLine];

    }
    return self;
}
- (void)layoutSubviews
{
  
    
}

// 重置所有View的Frame
-(void)resetAllViewFrame
{
    // 删除按钮
    [delResult setCenterY:self.height/2];
//     delResult.right = self.width - 20;
    
    // 投注号码
    int lblWidth = self.width-(IsPad?60:64);
    CGRect cFrame=CGRectMake(15,0,lblWidth,self.height-10);
    [numberLabel setFrame:cFrame];
    
    // 玩法
    cFrame = CGRectMake(cFrame.origin.x,self.height-20,0,20);
    [playLabel setFrame:cFrame];
    
    // 金额
    cFrame = CGRectMake(0,self.height-20,0,20);
    [moneyLabel setFrame:cFrame];
    
    // 虚线
    cFrame = CGRectMake(15,self.height-1,self.width-30,0.5);
    //[sepLine setFrame:cFrame];
    
   
}

#pragma 设置请求结果
-(void)setBetResult:(BetResult *)res
{
    if(res)
    {
        // 玩法 钱
        NSLog(@"res－－－%@",res.numbers);    // 选的号码
        NSLog(@"res－－－%@",res.lot_pk);     // 彩种编号
        NSLog(@"res－－－%@",res.play_code);  // 玩法编号
        
        // 重置frame
        [self resetAllViewFrame];
        
        [playLabel setText:getPlayTypeName([res.play_code intValue])]; // 玩法
        [moneyLabel setText:[NSString stringWithFormat:@"%li注 %li元",    //
                             res.zhushu,res.zhushu*2]];
        
        NSArray *array = [BetResultCell parseBetNumbers:res];
        NSMutableAttributedString *mulString = nil;
        // 判断是否为大乐透 和双色球
        if ([array count] == 2)
        { // 大乐透用两个label实现红蓝两种颜色
            NSString *attributText = [array[0] stringByAppendingString:[NSString stringWithFormat:@"  %@",array[1]]];
            //选中的号码赋值
            mulString = [[NSMutableAttributedString alloc] initWithString:attributText];
            
            NSString *redtext = array[0];
            NSString *bluetext = array[1];
            
            // 设置红色
            [mulString setAttributes:@{NSForegroundColorAttributeName:REDFONTCOLOR} range:NSMakeRange(0,redtext.length)];
            
            // 设置蓝色
            [mulString setAttributes:@{NSForegroundColorAttributeName:BLUEBALLCOLOR} range:NSMakeRange(redtext.length+2, bluetext.length)];
        }
        else if (array.count ==1)
        {
            // 其他彩种
            mulString = [[NSMutableAttributedString alloc] initWithString:array[0]];
            [mulString setAttributes:@{NSForegroundColorAttributeName:REDFONTCOLOR} range:NSMakeRange(0,[array[0] length])];
        }
        // 赋值
        numberLabel.attributedText = mulString;
        
        // 计算玩法和注数、金额的Lable宽度
        CGSize size = [playLabel.text sizeWithAttributes:@{NSFontAttributeName:playLabel.font}];
        [playLabel setWidth:size.width];
        size = [moneyLabel.text sizeWithAttributes:@{NSFontAttributeName:moneyLabel.font}];
        [moneyLabel setWidth:size.width];
        moneyLabel.left = playLabel.right+20;
    }
}

#pragma mark -- 解析投注格式为用户可见格式
+(NSMutableArray*) parseBetNumbers:(BetResult*)bean
{
    // 判断开奖号码是否为单号
    int ball_len = isSingleBall([bean.lot_pk intValue]) ? 1 : 2;
    NSMutableArray *textArray = [NSMutableArray array];
    
    switch ([bean.play_code intValue])
    {// 玩法
        // 大乐透单式
        case pDLT_Danshi:
        {
            if (bean.zhushu > 1)
            {
                //先将说有的球按注数分开
                NSArray *allNums = [bean.numbers componentsSeparatedByString:@"#"];
                for (int i = 0; i < allNums.count; i++)
                {
                    //拆封单柱的没一个选号
                    if (i != 0)
                    {
                        [AttributeColorLabel addText:@" | " color:nil font:nil
                                             toArray:textArray];
                    }
                    //将前面的10个红球分割成两个两个的
                    NSString *number = [allNums objectAtIndex:i];
                    [AttributeColorLabel addText:[[number substringToIndex:10]
                                                  commonString:@" " length:2]
                                           color:nil font:nil toArray:textArray];
                    //添加空格
                    [AttributeColorLabel addText:@" " color:nil
                                            font:nil toArray:textArray];
                    //分割蓝球
                    [AttributeColorLabel addText:[[number substringFromIndex:10]
                                                  commonString:@" " length:2]
                                           color:nil font:nil toArray:textArray];
                }
            }
            //一注的情况
            else
            {
                // 前面五个数字
                NSString *redStr = [[bean.numbers substringToIndex:10]commonString:@" " length:2];
                // 后面两个
                NSString *bluedStr = [[bean.numbers substringFromIndex:10]commonString:@" " length:2];
                
                [textArray addObject:redStr];
                [textArray addObject:bluedStr];
            }
        }
            break;
        // 大乐透复式
        case pDLT_Fushi:
        {
            
            NSArray *allNums = [bean.numbers componentsSeparatedByString:@"#"];
            // 红色
            NSString *redStr = [[allNums objectAtIndex:0] commonString:@" " length:2];
            // 蓝色
            NSString *bluedStr = [[allNums objectAtIndex:1] commonString:@" " length:2];
            [textArray addObject:redStr];
            [textArray addObject:bluedStr];
            
        }
            break;
            
        //大乐透胆托
        case pDLT_Dantuo:
        {
            NSArray *allNums = [bean.numbers componentsSeparatedByString:@"#"];
            
            // 前区胆拖
            NSArray *part = [[allNums objectAtIndex:0] componentsSeparatedByString:@"A"];
            NSString *qianDan = [NSString stringWithFormat:@"(%@)",
                                 [part[0] commonString:@" " length:2]];
            
            NSString *qianTuo = [part[1] commonString:@" " length:2];
            NSString *qianQu = [qianDan stringByAppendingFormat:@"%@|",qianTuo];
            
           
            part = [[allNums objectAtIndex:1] componentsSeparatedByString:@"A"];
            NSString *houDan = [NSString stringWithFormat:@"(%@)",
                                [part[0] commonString:@" " length:2]];
            
            NSString *houTuo = [part[1] commonString:@" " length:2];
            NSString *houQu = [houDan stringByAppendingString:houTuo];
            [textArray addObject:qianQu];
            [textArray addObject:houQu];
        }
            break;
        //双色球单式
        case pSSQ_Danshi:
        {
            if (bean.zhushu > 1)
            {
                //先将说有的球按注数分开
                NSArray *allNums = [bean.numbers componentsSeparatedByString:@"#"];
                for (int i = 0; i < allNums.count; i++)
                {
                    //拆封单柱的没一个选号
                    if (i != 0)
                    {
                        [AttributeColorLabel addText:@" | " color:nil font:nil
                                             toArray:textArray];
                    }
                    //将前面的12个红球分割成两个两个的
                    NSString *number = [allNums objectAtIndex:i];
                    [AttributeColorLabel addText:[[number substringToIndex:12]
                                                  commonString:@" " length:2]
                                           color:nil font:nil toArray:textArray];
                    //添加空格
                    [AttributeColorLabel addText:@" " color:nil
                                            font:nil toArray:textArray];
                    //分割蓝球
                    [AttributeColorLabel addText:[[number substringFromIndex:12]
                                                  commonString:@" " length:2]
                                           color:nil font:nil toArray:textArray];
                }
            }
            //一注的情况
            else
            {
                // 前面六个数字
                NSString *redStr = [[bean.numbers substringToIndex:12]commonString:@" " length:2];
                // 后面1个
                NSString *bluedStr = [[bean.numbers substringFromIndex:12]commonString:@" " length:2];
                
                [textArray addObject:redStr];
                [textArray addObject:bluedStr];
            }
            
        }
            break;
        //双色球复式
        case pSSQ_Fushi:
        {
            NSArray *allNums = [bean.numbers componentsSeparatedByString:@"#"];
            // 红色
            NSString *redStr = [[allNums objectAtIndex:0] commonString:@" " length:2];
            // 蓝色
            NSString *bluedStr = [[allNums objectAtIndex:1] commonString:@" " length:2];
            [textArray addObject:redStr];
            [textArray addObject:bluedStr];
        }
            break;
            
        //双色球胆拖
        case pSSQ_Dantuo:
        {
            NSArray *allNums = [bean.numbers componentsSeparatedByString:@"#"];
            // 前区胆拖
            NSString *qianDan = [NSString stringWithFormat:@"(%@)",
                                 [allNums[0] commonString:@" " length:2]];
            
            NSString *qianTuo = [allNums[1] commonString:@" " length:2];
            
            NSString *qianQu = [qianDan stringByAppendingFormat:@"%@",qianTuo];
            NSString *blueBall = [NSString stringWithFormat:@" %@",
                                [allNums[2]  commonString:@" " length:2]];
            
            [textArray addObject:qianQu];
            [textArray addObject:blueBall];
            
        }
            break;
            
        //(22选5，36选7，31选7)胆托
        case pT225_Dantuo:
        case pT317_Dantuo:
        case pT367_Dantuo:
        {
            NSArray *allNums = [bean.numbers componentsSeparatedByString:@"#"];
            NSString *danStr = [[allNums objectAtIndex:0] commonString:@" " length:2];
            NSString *tuodStr = [[allNums objectAtIndex:1] commonString:@" " length:2];
            NSString *textStr = [danStr stringByAppendingFormat:@"#%@",tuodStr];
            [textArray addObject:textStr];
            
        }break;
        
            // 七星彩
        case pSenvenStarLottery_Danshi:
        case pSenvenStarLottery_Fushi:
            // 排列三
        case pPL3_DirectChoice_Danshi:
        case pPL3_DirectChoice_Fushi:
        case pPL3_DirectChoice_Group3_Danshi:
        case pPL3_DirectChoice_Group3_Fushi:
        case pPL3_DirectChoice_Group6_Danshi:
        case pPL3_DirectChoice_Group6_Fushi:

        // 排列五
        case pPL5_Danshi:
        case pPL5_Fushi:
        {
            if (bean.zhushu > 1 || pXysc_Second_Duiwei==[bean.lot_pk intValue]
                || pXysc_Third_Duiwei == [bean.lot_pk intValue]) {
                if ([bean.numbers rangeOfString:@"#"].length == 0) {// 为空
                    NSString *numStr = [bean.numbers commonString:@" " length:ball_len];
                    [textArray addObject:numStr];
                }else{
                    [textArray addObject:bean.numbers];
                }
               
            } else
            {// 注数等于1
                NSString *numStr = [bean.numbers commonString:@" " length:ball_len];
                [textArray addObject:numStr];
            }
        }break;
            // 31 选7
        case pT317_Danshi:
        case pT317_Fushi:
            // 36 选7
        case pT367_Danshi:
        case pT367_Fushi:
            // 22 选5
        case pT225_Danshi:
        case pT225_Fushi:
        {
            [textArray addObject:[bean.numbers commonString:@" " length:2]];
           
        }
            break;
        default:
            [textArray addObject:bean.numbers];
            break;
    }
    return textArray;
}
#pragma mark - 计算结果Label的size
-(CGSize)calcCellSize
{
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : numberLabel.font, NSParagraphStyleAttributeName : style };
    CGRect rect = [numberLabel.attributedText.string boundingRectWithSize:CGSizeMake(numberLabel.width-30, 300) options:opts attributes:attributes context:nil];
    return rect.size;
}
#pragma mark -- 重新填充Cell
-(void)setNeedsLayout
{
    [super setNeedsLayout];
    //默认调用layoutSubViews，就可以处理子视图中的一些数据
    
    CGSize size = [self calcCellSize];
    [self setHeight:size.height+50.6];
    [numberLabel setHeight:size.height+26];
    [moneyLabel setTop:size.height+16];
    [playLabel setTop:size.height+16];
    [delResult setTop:(self.height-delResult.height)/2];
    [sepLine setTop:self.height-1];
    
 
}



@end