//
//  UICustomDialog.m
//  Workout
//
//  Created by liuchan on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UICustomDialog.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+NumberSplit.h"
#import "AttributeColorLabel.h"
#import "UtilMethod.h"

@implementation UICustomDialog

@synthesize titleLabel;
@synthesize messageLabel;
@synthesize isShowing;
@synthesize okButton,cancelButton;


// 获得当前窗口
-(UIWindow*) getKeyWindow
{
    UIWindow *keyWind = [UIApplication sharedApplication].keyWindow;
    if(!keyWind)
        keyWind = [[UIApplication sharedApplication].windows objectAtIndex:0];
    return keyWind;
}

-(id)init
{
    if (self = [super init]) {
        if(IsPad) [self loadDialogWidth:300 height:420];
        
        if(!IsPad) {
            UIView *parent = [self getKeyWindow];
            [self loadDialogWidth:parent.width-20
                           height:parent.height-100];
        }
    }
    return self;
}

-(id)initWithHeight:(int)height
{
    if (self = [super init]) {
        if(IsPad) [self loadDialogWidth:300 height:height];
        
        if(!IsPad) {
            UIView *parent = [self getKeyWindow];
            [self loadDialogWidth:parent.width-20
                           height:height];
        }
    }
    return self;
}

-(void)loadDialogWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat pHeight = [self getKeyWindow].frame.size.height;
    CGFloat pWidth = [self getKeyWindow].frame.size.width;
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, pWidth, pHeight)];
    [self setCenter:CGPointMake(pWidth/2, pHeight/2)];
    
    UIImage *mainBGImage = [[UIImage imageWithColor:[UIColor whiteColor] size:self.size] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 5, 10)];
    CGRect cFrame = CGRectMake((pWidth-width)/2, (pHeight-height)/2, width, height);
    container = [[UIImageView alloc] initWithFrame:cFrame];
    [container setUserInteractionEnabled:YES];
    [container setImage:mainBGImage];
    [container.layer setBorderColor:toPCcolor(@"#666666").CGColor];
    [container.layer setBorderWidth:0];
    [container.layer setCornerRadius:10];
    [container.layer setMasksToBounds:YES];
    width = container.frame.size.width;
    height = container.frame.size.height;
    
    // dialog顶部标题
    titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, width-10, 36)];
    UIImageView *titleBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"picker_module_above"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 36, 6)]];
    [titleBG setFrame:CGRectMake(0, 0, titleView.width, titleView.height)];
    [titleView insertSubview:titleBG atIndex:0];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, width-56, 36)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setShadowColor:[UIColor blackColor]];
    [titleLabel setShadowOffset:CGSizeMake(0.5, 0.5)];
    [titleLabel setText:LocStr(@"alert")];
    [titleView addSubview:titleLabel];
    
    UIImage *closeBg1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"close_normal@2x.png" ofType:@"nil"]];
    //[SDKBundle() pathForResource:@"close_normal@2x.png" ofType:nil]
    UIImage *closeBg2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"close_press@2x.png" ofType:nil]];
    //[SDKBundle() pathForResource:@"close_press@2x.png" ofType:nil]
    closeButton = [[UIButton alloc] init];
    [closeButton setSize:CGSizeMake(24,24)];
    [closeButton setCenterY:titleView.height/2];
    [closeButton setRight:titleView.width-5];
    [titleView addSubview:closeButton];
    [closeButton setHidden:YES];
    [closeButton setImage:closeBg1 forState:UIControlStateNormal];
    [closeButton setImage:closeBg2 forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(dismiss)
          forControlEvents:UIControlEventTouchUpInside];
    
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,24,24)];
    [iconView setCenterY:titleView.height/2];
    [iconView setHidden:YES];
    [titleView addSubview:iconView];
    
    // dialog中间内容
    contentView = [[UIView alloc] initWithFrame:CGRectZero];
    if(!IsPad) [contentView setFrame:CGRectMake(5,36,width-10,height-82)];
    else [contentView setFrame:CGRectMake(3,32,width-10,height-82)];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 6,270,6);
    UIImageView *centerBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"picker_module_mid"] resizableImageWithCapInsets:inset]];
    [centerBG setFrame:CGRectMake(0, 0, contentView.width, contentView.height)];
    [contentView insertSubview:centerBG atIndex:0];
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,contentView.width-16,contentView.height-16)];
    [messageLabel setNumberOfLines:0];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:messageLabel];
    
    // dialog底部按钮
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, height-46, width, 46)];
    inset = UIEdgeInsetsMake(0, 6, 46, 6);
    UIImageView *bottomBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"picker_module_bottom"] resizableImageWithCapInsets:inset]];
    [bottomBG setFrame:CGRectMake(0, 0, bottomView.width, bottomView.height)];
    [bottomBG setBackgroundColor:[UIColor grayColor]];
    [bottomBG setAlpha:0.3];
    [bottomView insertSubview:bottomBG atIndex:0];
    // 确定按钮
    okButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 7, 120, 32)];
    [okButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [okButton.titleLabel setShadowColor:[UIColor blackColor]];
    [okButton.titleLabel setShadowOffset:CGSizeMake(0.2, 0.2)];
    [okButton setGeneralBgWithSize:okButton.size];
    [okButton setTitle:LocStr(@"ok") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(dismiss)
       forControlEvents:UIControlEventTouchUpInside];
    // 取消按钮
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 7, 120, 32)];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [cancelButton.titleLabel setTextColor:[UIColor whiteColor]];
    [cancelButton.titleLabel setShadowColor:[UIColor blackColor]];
    [cancelButton.titleLabel setShadowOffset:CGSizeMake(0.2, 0.2)];
    [cancelButton setGeneralBgWithSize:cancelButton.size];
    [cancelButton setTitle:LocStr(@"cancel") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:okButton];
    [bottomView addSubview:cancelButton];
    [container addSubview:titleView];
    [container addSubview:contentView];
    [container addSubview:bottomView];
    [self addSubview:container];
}

-(UICustomDialog*)setOkButton:(NSString*)okTitle nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor target:(id)target action:(SEL)action
{
    if (isValidateStr(okTitle)) {
        [okButton setHidden:NO];
        [okButton setTitle:okTitle forState:UIControlStateNormal];
        [okButton setTitleColor:nColor forState:UIControlStateNormal];
        [okButton setTitleColor:hColor forState:UIControlStateHighlighted];
    } else {
        [okButton setHidden:YES];
        [cancelButton setWidth:cancelButton.width*2];
        [cancelButton setCenterX:bottomView.width/2];
    }
    
    if(target && action){
        [okButton addTarget:target action:action
           forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(UICustomDialog*)setCancelButton:(NSString*)cancelTitle nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor target:(id)target action:(SEL)action
{
    if (isValidateStr(cancelTitle)) {
        [cancelButton setHidden:NO];
        [cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:nColor forState:UIControlStateNormal];
        [cancelButton setTitleColor:hColor forState:UIControlStateHighlighted];
    } else {
        [cancelButton setHidden:YES];
        [okButton setWidth:okButton.width*2];
        [okButton setCenterX:bottomView.width/2];
    }
    
    if(target && action){
        [cancelButton addTarget:target action:action
               forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)hideCancelButton
{
    [cancelButton setHidden:YES];
    if(!okButton.hidden){
        okButton.center = CGPointMake(bottomView.bounds.size.width/2,bottomView.bounds.size.height/2);
    }
}

-(void)hideOkButton
{
    [okButton setHidden:YES];
    if(!cancelButton.hidden){
        cancelButton.center = CGPointMake(bottomView.bounds.size.width/2,bottomView.bounds.size.height/2);
    }    
}

-(UICustomDialog*)setIcon:(UIImage*)icon
{
    if(icon.size.height>iconView.height)
        icon = [UIImage imageWithCGImage:icon.CGImage
                                   scale:(iconView.height/icon.height)
                             orientation:UIImageOrientationUp];
    
    if(icon.size.width>iconView.width)
        icon = [UIImage imageWithCGImage:icon.CGImage
                                   scale:(iconView.width/icon.width)
                             orientation:UIImageOrientationUp];
    
    if(icon){
        [iconView setImage:icon];
        [iconView setHidden:NO];
        [titleLabel setLeft:iconView.right+3];
    }
    
    return self;
    
}

-(UICustomDialog *)setTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(NSTextAlignment)titleAlignment titleFont:(UIFont *)titleFont
{
    if(title){
        [titleLabel setText:title];
        titleLabel.textColor = titleColor;
        titleLabel.textAlignment = titleAlignment;
        titleLabel.font = titleFont;
    }
    
    return self;
}

-(UICustomDialog *)setMessage:(NSString *)message
{
    if (message) {
        [messageLabel setText:message];
    }
    return self;
}

-(UICustomDialog *)setMessage:(NSString *)message autoHeight:(BOOL)isAuto
{
    if(isAuto){
        int maxWidth = IsPad?300:messageLabel.width;
        CGSize size = [message sizeWithFont:messageLabel.font
                          constrainedToSize:CGSizeMake(maxWidth,1000)
                              lineBreakMode:NSLineBreakByCharWrapping];
        [messageLabel setHeight:size.height+5];
        [contentView setHeight:size.height+messageLabel.top*2+5];
        [bottomView setTop:contentView.bottom];
        [container setHeight:titleView.height+contentView.height+bottomView.height];
        [container setCenterY:self.height/2];
    }
    return [self setMessage:message];
}

-(UICustomDialog *)setContentView:(UIView *)v atPos:(int)pos
{
    if (!v)
        return self;
    
    // 根据位置计算view的坐标
    CGRect frame = v.bounds;
    switch (pos) {
        case centerPos:
            frame.origin = CGPointMake(0,(contentView.height-v.height)/2);
            break;
        case bottomPos:
            frame.origin = CGPointMake(0,contentView.height-v.height);
            break;
    }
    
    // 添加view到contentView
    [messageLabel removeFromSuperview];
    [v setFrame:frame];
    [contentView addSubview:v];
    return self;
}

-(void)layoutSubviews
{
    UIWindow *window = [self getKeyWindow];
    [self setFrame:window.bounds];
    [container resetOrientation];
}

-(void)deviceOrientationDidChange:(id)sender
{
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        [container resetOrientation];
    }];
}

-(void)showCloseButton
{
    [closeButton setHidden:NO];
}

-(void)show
{
    NSString *notifyName = UIDeviceOrientationDidChangeNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:notifyName object:nil];
    isShowing = YES;
    if(IsPad) [container resetOrientation];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setTransform:CGAffineTransformMakeScale(0.6, 0.6)];
    [self setAlpha:0.4];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0];
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished) {
        [self setBackgroundColor:toPCcolor(@"#66000000")];
    }];
}

-(void)dismissWitoutAnimation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    isShowing = NO;
    [self removeFromSuperview];
}

-(void)dismiss
{
    isShowing = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0];
        [self setTransform:CGAffineTransformMakeScale(0.6, 0.6)];
    } completion:^(BOOL finished) {
        [self dismissWitoutAnimation];
    }];
}

-(void)setBetArray:(NSArray*)theArray
{
    _betsArray = theArray;
    [_betsTable removeFromSuperview];
    UIImage *resultBG = [[UIImage imageNamed:@"bet_result_bg_small"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 11, 0)];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:resultBG];
    [bgView setFrame:contentView.bounds];
    [bgView setWidth:resultBG.size.width];
    [bgView setHeight:bgView.height-10];
    [bgView setCenter:CGPointMake(contentView.width/2,
                                  contentView.height/2)];
    [contentView addSubview:bgView];

    _betsTable = [[UITableView alloc] initWithFrame:bgView.frame];
    [_betsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_betsTable setBackgroundColor:[UIColor clearColor]];
    [_betsTable setShowsVerticalScrollIndicator:NO];
    [_betsTable setWidth:bgView.width-20];
    [_betsTable setHeight:bgView.height-10];
    [_betsTable setCenter:bgView.center];
    [_betsTable setBackgroundView:nil];
    [_betsTable setDataSource:self];
    [_betsTable setDelegate:self];
    [_betsTable setBounces:NO];
    [contentView addSubview:_betsTable];
}

#define Cell_Identifier @"Cell_Identifier"
#define TAG_Color_Label 1111
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell_Identifier];
        [cell setSize:CGSizeMake(_betsTable.width, 32)];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectZero];
        [sepView setBackgroundColor:toPCcolor(@"#cccccc")];
        [sepView setWidth:cell.contentView.width];
        [sepView setBottom:32];
        [sepView setHeight:0.5];
        [cell addSubview:sepView];
        
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        [colorLabel setBackgroundColor:[UIColor clearColor]];
        [colorLabel setTextColor:REDFONTCOLOR];
        [colorLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [colorLabel setTag:TAG_Color_Label];
        [cell addSubview:colorLabel];
    }
#warning 显示
    BetResult *br = [_betsArray objectAtIndex:indexPath.row];
    AttributeColorLabel *textLabel = (AttributeColorLabel*)[cell viewWithTag:TAG_Color_Label];;
    if([br.lot_pk intValue]==kType_CTZQ_SF9){
        [textLabel addText:[[br.numbers substringToIndex:10] commonString:@" " length:2]
                     color:nil font:nil];
        [textLabel addText:@" " color:nil font:nil];
        [textLabel addText:[[br.numbers substringFromIndex:10] commonString:@" " length:2]
                     color:[UIColor redColor] font:nil];
    } else {
        [textLabel addText:[br.numbers commonString:@" " length:isSingleBall([br.lot_pk intValue])?1:2] color:nil font:nil];
    }
    CGSize size = [[textLabel drawColorString] sizeWithFont:textLabel.font constrainedToSize:cell.size];
    [textLabel setSize:CGSizeMake(size.width, size.height)];
    [textLabel setCenter:CGPointMake(cell.width/2,cell.height/2)];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _betsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
