//
//  AccountCell.m
//  LotteryUnion
//
//  Created by happyzt on 15/11/6.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AccountCell.h"
#import "NSString+ConvertDate.h"

@implementation AccountCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
       
        [self _createSubViews];
    }
    
    return self;
}

- (void)_createSubViews {
    
    // 类型
    _pay_type = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (mScreenWidth-20)/4, self.height+10)];
    [_pay_type setBackgroundColor:[UIColor clearColor]];
    _pay_type.numberOfLines = 0;
    [_pay_type setFont:[UIFont systemFontOfSize:12]];
//    _pay_type.backgroundColor = [UIColor redColor];
    [_pay_type setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_pay_type];
    
    // 金额
    _money = [[UILabel alloc] initWithFrame:CGRectMake(_pay_type.width, self.height/2-10, (mScreenWidth-20)/4, 30)];
    [_money setBackgroundColor:[UIColor clearColor]];
    [_money setFont:[UIFont systemFontOfSize:12]];
    [_money setTextAlignment:NSTextAlignmentCenter];
//     _money.backgroundColor = [UIColor greenColor];
    [self addSubview:_money];
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(_pay_type.width*2, 0, (mScreenWidth-20)/4, self.height+10)];
    [_time setBackgroundColor:[UIColor clearColor]];
    [_time setFont:[UIFont systemFontOfSize:12]];
    [_time setTextAlignment:NSTextAlignmentCenter];
    _time.numberOfLines = 0;
    [self addSubview:_time];
    
    //状态
    _status = [[UILabel alloc] initWithFrame:CGRectMake(_pay_type.width*3, self.height/2-10,(mScreenWidth-20)/4, 30)];
    [_status setBackgroundColor:[UIColor clearColor]];
    [_status setFont:[UIFont systemFontOfSize:12]];
    [_status setTextAlignment:NSTextAlignmentCenter];
//     _status.backgroundColor = [UIColor yellowColor];
    [self addSubview:_status];
    
    
}


- (void)winModel:(WinModel *)model sign:(BOOL)decost tag:(int)tag{
    
    _winModel = model;
    _tag = tag;
    
    _money.text = [NSString stringWithFormat:@"%@元", _winModel.money];
    if (decost) {
        _money.textColor = RGBA(235, 70, 75, 1);
    }else {
        _money.textColor = RGBA(0, 165, 175, 1);
    }
    _time.text = [_winModel.create_time toFormatDateString];
    
    NSLog(@"_winModel.pay_type = %@",_winModel.pay_type);
    if ([_winModel.pay_type isEqual:@"支付宝"]) {
        _pay_type.text = _winModel.pay_type;
    }else {
        switch ([_winModel.pay_type intValue]) {
            case 0:                //处理中
                _pay_type.text = @"处理中";
                break;
            case 2:                 //2：现金
                _pay_type.text = @"现金";
                break;
            case 5:                 //5：账户
                _pay_type.text = @"账户";
                break;
            case 4:                 //4：账户
                _pay_type.text = @"账户";
                break;
            case 6:                  //6：手机支付
                _pay_type.text = @"(和包)手机支付";
                break;
            case 8:                  //8：银行卡
                _pay_type.text = @"银行卡";
                break;
            case 30:                  //30：话费
                _pay_type.text = @"话费";
                break;
        }
    }

    if ([self.winModel.status isEqual:@"-1"]) {          //其他
        _status.text = @"其他";
    }else if ([self.winModel.status isEqual:@"0"]) {     //受理中
        _status.text = @"受理中";
    }else if ([self.winModel.status isEqual:@"1"]) {   //成功
        _status.text = @"成功";
    }else if ([self.winModel.status isEqual:@"2"]) {   //失败
        _status.text = @"失败";
    }
}


@end
