//
//  AwardDetailCell.m
//  LotteryUnion
//
//  Created by happyzt on 15/10/30.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AwardDetailCell.h"
#import "NSString+stringToSpecialNumber.h"

@implementation AwardDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}


-(void)detailArray:(NSMutableArray *)array lottery_pk:(NSString *)lottery_pk
{
    // 设置数据
    _detailArray = array;
    _lottery_pk = lottery_pk;
    
}

- (void)DLTArray:(NSMutableArray *)array lottery_pk:(NSString *)lottery_pk {
    _DLTArray = array;
    _lottery_pk = lottery_pk;
}

// 设置数据
- (void)layoutSubviews{
    
     UILabel *label1 = (UILabel *) [self viewWithTag:1000];
     UILabel *label2 = (UILabel *) [self viewWithTag:1001];
     UILabel *label3 = (UILabel *) [self viewWithTag:1002];
     UILabel *label4 = (UILabel *) [self viewWithTag:1003];
     UILabel *label5 = (UILabel *) [self viewWithTag:1004];
     UILabel *label6 = (UILabel *) [self viewWithTag:1005];
     NSString *dot1 = [NSString stringToNumberWithDot:[_detailArray[0] floatValue]];
     NSString *dot = [NSString stringToNumberWithDot:[_detailArray[1] floatValue]];
     NSString *dot11 = [NSString stringToNumberWithDot:[_DLTArray[1] floatValue]];
     NSString *dot22 = [NSString stringToNumberWithDot:[_DLTArray[2] floatValue]];
     NSString *dot2 = [NSString stringToNumberWithDot:[_DLTArray[3] floatValue]];
     NSString *dot3 = [NSString stringToNumberWithDot:[_DLTArray[4] floatValue]];
    
    if ([_lottery_pk integerValue] == lDLT_lottery)
    {
        label1.text = _DLTArray[0];
        label2.text = [dot11 substringToIndex:dot11.length-3];
        label3.text = [dot22 substringToIndex:dot22.length-3];
        label4.text = [NSString stringWithFormat:@"%@-追加",_DLTArray[0]];
        label5.text = [dot2 substringToIndex:dot2.length-3];
        label6.text = [dot3 substringToIndex:dot3.length-3];
        
        if ([label4.text isEqual:@"六等奖-追加"]) {
            label4.text = @"";
            
            if ([label5.text isEqual:@"0"]) {
                label5.text = @"";
            }else {
                label5.text = [dot2 substringToIndex:dot2.length-3];
            }
            
            if ([label6.text isEqual:@"0"]) {
                label6.text = @"";
            }else {
                label6.text = [dot3 substringToIndex:dot3.length-3];
            }
            
        }else {
            label4.text = [NSString stringWithFormat:@"%@-追加",_DLTArray[0]];
            label6.text = [dot3 substringToIndex:dot3.length-3];
            label5.text = [dot2 substringToIndex:dot2.length-3];
        }
    
        
    }else {
        _prizeLabel.text = _detailArray[2];
        _amountLabel.text = [dot1 substringToIndex:dot1.length-3];
        _moneyLabel.text = [dot substringToIndex:dot.length-3];
    }
}


-(void)drawRect:(CGRect)rect
{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -1.75, mScreenWidth, 2)];
    
    [self.contentView addSubview:imageView1];
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, -1.8, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    //设置线条终点形状
    CGFloat lengths[] = {1,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 1.5);    //开始画线
    CGContextAddLineToPoint(line, imageView1.width, 1.5);
    CGContextStrokePath(line);
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
}





@end
