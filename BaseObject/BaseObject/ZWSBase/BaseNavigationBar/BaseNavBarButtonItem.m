//
//  BaseNavBarButtonItem.m
//  MoodMovie
//
//  Created by 周文松 on 14-8-28.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//
typedef enum {
    NavBarButtonItemTypeDefault = 0,
    NavBarButtonItemTypeBack,
    NavBarButtonItemTypeRight

} NavBarButtonItemType;

#import "BaseNavBarButtonItem.h"

@implementation BaseNavBarButtonItem

- (id)initWithType:(NavBarButtonItemType)itemType image:(NSString *)image title:(NSString *)title
{
    self = [super init];
    if (self)
    {
        
        UIImage *img = image?[UIImage imageNamed:image]:nil;
        CGSize imageSize = img.size;
        CGSize titleSize = [self createTitle:title font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(100,[UIFont systemFontOfSize:16].lineHeight)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(0, 0, imageSize.width + titleSize.width, (img.size.height - titleSize.height > 0?imageSize.height:titleSize.height));
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        self.button  = button;
    }
	
    return self;
}

- (id)initWithType:(NavBarButtonItemType)itemType images:(NSArray *)images titles:(NSArray *)titles
{
    if ((self = [super init])) {
        if (images.count) {
            
            UIView *view = [UIView new];
            for (int i = 0; i < images.count; i ++)
            {
                UIImage *img = [UIImage imageNamed:images[i]];
                CGSize imageSize = img.size;
                CGSize titleSize = [self createTitle:titles[i] font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(100, [UIFont systemFontOfSize:16].lineHeight)];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 0, imageSize.width + titleSize.width, (img.size.height - titleSize.height > 0?imageSize.height:titleSize.height));
                button.titleLabel.font = [UIFont systemFontOfSize:16];
                view.frame= button.frame;
                [view addSubview:button];
                
            }
            
            [self.view addSubview:view];
        }
    }
    return self;
}


- (CGSize)createTitle:(NSString *)title  font:(UIFont *)font maxSize:(CGSize)maxSize
{
    if (title.length) {
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:title attributes:attributes];
        
        CGRect rect = [attributedText boundingRectWithSize:maxSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        
        return rect.size;
    }
    return CGSizeZero;
    
}


- (void)setTarget:(id)target withAction:(SEL)action
{
    if(self.button)
    {
        [_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [_button setImage:self.image forState:UIControlStateNormal];
    }
    if (self.title) {
        [_button setTitle:self.title forState:UIControlStateNormal];
    }
}




+ (id)itemWithTarget:(id)target title:(NSString *)title action:(SEL)action image:(NSString *)image;
{
    BaseNavBarButtonItem *buttonItem = [[BaseNavBarButtonItem alloc] initWithType:NavBarButtonItemTypeBack image:image  title:title];
    if (image) {
        buttonItem.image = [UIImage imageNamed:image];
    }
    buttonItem.title = title;
    [buttonItem setTarget:target withAction:action];
    return buttonItem;

}

+ (id)itemWithTarget:(id)target titles:(NSArray *)titles actions:(NSArray *)actions images:(NSArray *)images;
{
    BaseNavBarButtonItem *buttonItem = [[BaseNavBarButtonItem alloc] initWithType:NavBarButtonItemTypeBack images:images  titles:titles];
    return buttonItem;
}


@end
