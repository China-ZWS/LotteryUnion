//
//  PopUpOptionView.m
//  ydtctz
//
//  Created by 小宝 on 1/18/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "PopUpOptionView.h"

@implementation PopUpOptionView
@synthesize numOfPeriod = _numOfPeriod;   // 期数
@synthesize mutiple = _mutilpe;           // 倍数
#define Print_text_color  [UIColor redColor]


- (id)initWithFrame:(CGRect)frame mutiple:(NSString *)mutiple period:(NSString *)period showFollowOption:(BOOL)showFollow
{
    self = [super initWithFrame:frame];
    if (self) {
        _data = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        
        _mutilpe = [mutiple intValue];   // 倍数
        _numOfPeriod = [period intValue];// 期数
        
        UIImage *mainBGImage = [[UIImage imageNamed:@"query_item_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 5, 10)];
        UIImageView *bgview2 = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.size]];
        [bgview2 setFrame:CGRectMake(0,mScreenHeight-290,mScreenWidth,290)];
        [bgview2 setUserInteractionEnabled:YES];
        [bgview2.layer setBorderColor:toPCcolor(@"#666666").CGColor];
        [bgview2.layer setBorderWidth:0];
        [bgview2.layer setCornerRadius:5];
        [bgview2.layer setMasksToBounds:YES];
        [self addSubview:bgview2];
        
        // dialog顶部标题
        CGRect titleFrame = CGRectMake(5, 0, bgview2.width, 36);
        UIImageView *titleView = [[UIImageView alloc] initWithFrame:titleFrame];
        titleFrame = CGRectMake(8, 0, bgview2.width-56, 36);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor blueColor]];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(0.5, 0.5)];
        [titleLabel setText:LocStr(@"请选择")];
        [titleView addSubview:titleLabel];
        [bgview2 addSubview:titleView];
        
        UIView *grayback = [[UIView alloc] initWithFrame:
                            CGRectMake(0,bgview2.height-46,bgview2.width,46)];
        grayback.backgroundColor = [UIColor clearColor];
        UIView *back_gray = [[UIView alloc] initWithFrame:grayback.frame];
        [back_gray setBackgroundColor:[UIColor grayColor]];
        [back_gray setAlpha:0.3];
        [bgview2 addSubview:back_gray];
        [bgview2 addSubview:grayback];

        if (showFollow) {
            UIButton *opButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [opButton setImage:[UIImage imageNamed:@"domo_checkbox.png"] forState:UIControlStateNormal];
            [opButton setImage:[UIImage imageNamed:@"domo_checkbox_press.png"] forState:UIControlStateSelected];
            [opButton setTitle:[NSString stringWithFormat:@" %@",LocStr(@"无限期")] forState:UIControlStateNormal];
            opButton.titleLabel.font = [UIFont systemFontOfSize:15];

            [opButton setTitleColor:Print_text_color forState:UIControlStateNormal];
            if (_numOfPeriod == -1)
                opButton.selected = YES;
            [opButton addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [opButton setTag:2];
            [opButton setFrame:CGRectMake(bgview2.width-120,bgview2.height-73,100,23)];
            [bgview2 addSubview:opButton];
        }
        
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [okButton setTitle:LocStr(@"确定") forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        okButton.titleLabel.font = [UIFont systemFontOfSize:14];
        okButton.frame = CGRectMake(20.0,7.0,120.0f,32.0f);
        [okButton addTarget:self action:@selector(ButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        [okButton setGeneralBgWithSize:okButton.size];
        [okButton setTag:0];
        [grayback addSubview:okButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:LocStr(@"取消") forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelButton.frame = CGRectMake(okButton.left+okButton.width+40,7.0,120,32);
        [cancelButton addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setGeneralBgWithSize:cancelButton.size];
        cancelButton.tag = 1;
        [grayback addSubview:cancelButton];
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.85, 0.85);
        transform = CGAffineTransformTranslate(transform, 0, -20);
        
        CGRect lblFrame = CGRectMake(65,7,40,20);
        ColorLabel *lbl1 = [[ColorLabel alloc] initWithFrame:lblFrame text:LocStr(@"倍数") color:Print_text_color];
        lbl1.font = [UIFont boldSystemFontOfSize:16];
        if (!showFollow)
            [lbl1 setLeft:bgview2.centerX - 20];
        [bgview2 addSubview:lbl1];
        
        // 倍数选择器
        picker1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,105,0)];
        picker1.showsSelectionIndicator = YES;
        [picker1.layer setMasksToBounds:YES];
        [picker1.layer setCornerRadius:10];
        [picker1 setTop:lbl1.bottom+2];
        [picker1 setCenterX:lbl1.centerX];
        picker1.delegate = self;
        picker1.dataSource = self;
        [picker1 setTransform:transform];
        [bgview2 addSubview:picker1];
        
        if (showFollow) {
            ColorLabel *lbl2 = [[ColorLabel alloc] initWithFrame:lblFrame text:LocStr(@"期数") color:Print_text_color];
            [lbl2 setLeft:195];
            lbl2.font = lbl1.font;
            [bgview2 addSubview:lbl2];
            
            picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,105,0)];
            [picker2 setShowsSelectionIndicator:YES];
            [picker2.layer setMasksToBounds:YES];
            [picker2.layer setCornerRadius:10];
            [picker2 setCenterX:lbl2.centerX];
            [picker2 setTop:lbl2.bottom+2];
            picker2.dataSource = self;
            picker2.delegate = self;
            [picker2 setTransform:transform];
            [bgview2 addSubview:picker2];
        }
    }
    return self;
}

-(void)showInWindow
{
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    
    [self setAlpha:0.5];
//    [self setTransform:CGAffineTransformMakeScale(0.6, 0.6)];
    [UIView animateWithDuration:0.5 animations:^{
        self.top = mScreenHeight - self.height;
        [self setAlpha:1];
//        [self setTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        [self setBackgroundColor:toPCcolor(@"#44000000")];
    }];
    
    NSInteger centerPos = _data.count*5000;
    [picker1 selectRow:_mutilpe/10+centerPos
           inComponent:0 animated:NO];
    [picker1 selectRow:_mutilpe%10+centerPos
           inComponent:1 animated:NO];
    
    if(!picker2) return;
    
    if (_numOfPeriod!=-1) {
        [picker2 selectRow:_numOfPeriod/10+centerPos
               inComponent:0 animated:NO];
        [picker2 selectRow:_numOfPeriod%10+centerPos
               inComponent:1 animated:NO];
    } else {
        [picker2 selectRow:centerPos
               inComponent:0 animated:NO];
        [picker2 selectRow:centerPos
               inComponent:1 animated:NO];
    }
}

-(void)dismiss
{
    [self setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0.0];
//        [self setTransform:CGAffineTransformMakeScale(0.6, 0.6)];
        self.top = mScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)ButtonClicked:(UIButton *)sender
{
    if ([sender tag] == 2) {
        sender.selected = !sender.selected;

        _unlimted = sender.selected;
        if (!_unlimted)
            _numOfPeriod = 0;
    } else {
        if (sender.tag == 0) {
            if (_unlimted)
                _numOfPeriod = -1;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        [self dismiss];
    }
}

//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// 每一列的row
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_data count]*10000;
}

// 给row赋值
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_data objectAtIndex:(row%_data.count)];
}


-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 40;
}

// 选中pickView某一行的响应方法（改变期数和倍数）
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 改变倍数期数（个，十）
    NSInteger shi = [picker1 selectedRowInComponent:0]%_data.count;
    NSInteger ge = [picker1 selectedRowInComponent:1]%_data.count;
    _mutilpe = [[NSString stringWithFormat:@"%ld%ld",shi,ge] intValue] ? :1;
    
    if (picker2){
        shi = [picker2 selectedRowInComponent:0]%_data.count;
        ge = [picker2 selectedRowInComponent:1]%_data.count;
        _numOfPeriod = [[NSString stringWithFormat:@"%ld%ld",shi,ge] intValue];
    }
}


@end
