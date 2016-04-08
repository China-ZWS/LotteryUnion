//
//  CustomTextView.m
//  OxygenPerson
//
//  Created by ZhangJC on 14-9-16.
//  Copyright (c) 2014年 pengxin. All rights reserved.
//

#import "CustomTextView.h"

@interface CustomTextView ()



@end

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
        self.enablesReturnKeyAutomatically = YES;
        self.returnKeyType = UIReturnKeyDone;
        self.delegate = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:16];
        self.textColor = toPCcolor(@"282828");
        
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.spellCheckingType = UITextSpellCheckingTypeNo;
    self.enablesReturnKeyAutomatically = YES;
    self.returnKeyType = UIReturnKeyDone;
    self.delegate = self;
    
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:16];
    self.textColor = toPCcolor(@"282828");
    
    [self commonInit];
}
- (void)commonInit
{
    // Insert as first subview so appears below the insertion marker etc.
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _placeholderLabel.textAlignment = NSTextAlignmentLeft;
    _placeholderLabel.textColor = toPCcolor(@"939393");
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.userInteractionEnabled = NO;
    _placeholderLabel.font = self.font;
    [_placeholderLabel sizeToFit];

    [self insertSubview:self.placeholderLabel atIndex:0];
    self.placeholderLabel.hidden = YES;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self updatePlaceholderLabelVisibility];
}

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}

- (void)updatePlaceholderLabelVisibility
{
    self.placeholderLabel.hidden = ([self.text length]) ? YES:NO;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    /// Force update placeholderLabel position
    [self caretRectForPosition:self.beginningOfDocument];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (range.length!=1&&[text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark UITextInput

- (UITextRange *)selectedTextRange
{
    [self updatePlaceholderLabelVisibility];
    return [super selectedTextRange];
}

- (UITextRange *)markedTextRange
{
    [self updatePlaceholderLabelVisibility];
    return [super markedTextRange];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect caretRect = [super caretRectForPosition:position];
    [self updatePlaceholderLabelVisibility];
    if ([self.text length] == 0) {
        [self.placeholderLabel sizeToFit];
        CGRect rect = CGRectZero;
        rect.size = self.placeholderLabel.frame.size;
        rect.origin = caretRect.origin;
        self.placeholderLabel.frame = rect;
    }
    return caretRect;
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
