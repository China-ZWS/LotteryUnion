//
//  wordsCountView.m
//  ShiDaWang
//
//  Created by 王家兴 on 13-11-11.
//  Copyright (c) 2013年 zhaohua. All rights reserved.
//

#import "wordsCountView.h"
#import <QuartzCore/QuartzCore.h>

@implementation wordsCountView
@synthesize labelWord;
@synthesize wordsNum;
@synthesize maxWords;
- (void)setMaxWords:(NSInteger)words
{
    maxWords = words;
    [self setWordsNum:0];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 求取文本宽度
- (NSInteger)getTextWidth:(NSString *)textNumber {
	CGSize detailSize = [textNumber sizeWithFont:[UIFont systemFontOfSize:LabelFontSize]
                               constrainedToSize:CGSizeMake(50, MAXFLOAT)
                                   lineBreakMode:NSLineBreakByCharWrapping];
	return detailSize.width;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
        labelWord = [[UILabel alloc] init];
		labelWord.tag = WordsLeftBtnTag;
		labelWord.font= [UIFont systemFontOfSize: LabelFontSize];
		labelWord.backgroundColor = [UIColor clearColor];
        labelWord.textAlignment = NSTextAlignmentRight;
		[self setWordsNum:wordsNum];
		[self addSubview:labelWord];
       
    }
    return self;
}
//TODO:修正字个数
- (void)textViewDidChange:(UITextView *)textView
{
    // 修正字个数
    [self setWordsNum:textView.text.length];

}
//TODO:字数监听
- (void)tfchange
{
    // 修正字个数
    [self setWordsNum:_targetField.text.length];
}
- (void)textViewchange
{
    // 修正字个数
    [self setWordsNum:_targetTextview.text.length];
}
//TODO:设置目标输入框
- (void)setTargetField:(UITextField *)targetField
{
      _targetField  = targetField;
     [mNotificationCenter addObserver:self selector:@selector(tfchange) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)setTargetTextview:(UITextView *)targetTextview
{
    _targetTextview  = targetTextview;
     [mNotificationCenter addObserver:self selector:@selector(textViewchange) name:UITextViewTextDidChangeNotification object:nil];
}
//TODO===========
// 重载set方法
- (void)setWordsNum:(NSInteger)counts {
    _iswordsOffset = NO;
	wordsNum = counts;
	NSString *numString = [NSString stringWithFormat:@"%d/%d", (int)wordsNum,(int)self.maxWords];
	labelWord.font = [UIFont systemFontOfSize: LabelFontSize];
    labelWord.textColor = [UIColor redColor];
	NSInteger width = [self getTextWidth:numString];
	if (wordsNum == self.maxWords ) {
		labelWord.frame = CGRectMake(0, 0, width + 15, 17);
		[labelWord setText:numString];
		[labelWord setTextColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0 ]];
	}
	else {
		labelWord.frame = CGRectMake(0, 0, width + 15, 17);
		[labelWord setText:numString];
		if (wordsNum > maxWords) {
            [labelWord setTextColor:[UIColor redColor]];
            _iswordsOffset = YES;
		}
		else {
            [labelWord setTextColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0 ]];
		}
	}
}
@end
