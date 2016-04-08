//
//  ArrowView.m
//  HCTProject
//
//  Created by 周文松 on 14-6-24.
//  Copyright (c) 2014年 com.talkweb.www.HCTProject. All rights reserved.
//

#import "ArrowView.h"
#import "Device.h"


@interface ArrowView ()
@property (nonatomic) ImageMode imageMode;
@end

@implementation ArrowView

- (void)dealloc
{
}

+(instancetype)buttonInstance{
    return [self buttonWithType:UIButtonTypeCustom];;
}


+(instancetype)buttonInstance:(ImageMode)imageMode
{
    ArrowView *btn = [self buttonWithType:UIButtonTypeCustom];
    btn.imageMode = imageMode;
    if (imageMode == kRight) {
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return btn;
}


-(instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //高亮的时候不要自动调整图标
        
        self.showsTouchWhenHighlighted = YES;
//        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = FontBold(17);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    
    
    return self;
    
}




/**
 
 *  自定义按钮图片的frame
 
 *
 
 *  @param contentRect
 
 *
 
 *  @return
 
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect

{
    CGFloat imageY = (contentRect.size.height - self.titleLabel.font.lineHeight) / 2 + self.titleLabel.font.lineHeight - self.currentImage.size.height - 2;
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageX = 0;
    if (_imageMode == kRight) {
        imageX = contentRect.size.width - imageW;
    }
    else
    {
        imageX = 0;
    }
    
    CGFloat imageH = self.currentImage.size.height;
    return  CGRectMake(imageX, imageY, imageW, imageH);
    
}

/**
 
 *  自定义按钮标题的frame
 
 *
 
 *  @param contentRect
 
 *
 
 *  @return
 
 */
-(CGRect)titleRectForContentRect:(CGRect)contentRect

{
    
    CGFloat titleY = 0;
    
    CGFloat titleW = contentRect.size.width - self.currentImage.size.width - 5;
    
    CGFloat titleX = 0;
    if (_imageMode == kRight) {
        titleX = 0;
    }
    else
    {
        titleX = self.currentImage.size.width + 5;
    }
    
    
    CGFloat titleH = contentRect.size.height;
    
    
    
    return CGRectMake(titleX, titleY, titleW, titleH);
    
}


/**
 
 *  根据Title设定自己的宽度
 
 *
 
 *  @param title
 
 *  @param state
 
 */

-(void)setTitle:(NSString *)title forState:(UIControlState)state

{
    
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    
    CGFloat titleW = titleSize.width;
    
    
    
    CGRect frame = self.frame;
    frame.size.width = titleW + self.currentImage.size.width + 5;
    self.frame = frame;
    [super setTitle:title forState:state];
    
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state
{
    
    CGSize titleSize = [[title string] sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    
    CGFloat titleW = titleSize.width;

    CGRect frame = self.frame;
    frame.size.width = titleW + self.currentImage.size.width + 5;
    self.frame = frame;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
