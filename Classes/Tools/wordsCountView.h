//
//  wordsCountView.h
//  ShiDaWang
//
//  Created by 王家兴 on 13-11-11.
//  Copyright (c) 2013年 zhaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

// 控件标记
#define WordsLeftBtnTag				500
#define	DeleteBtnTag				(WordsLeftBtnTag + 1)
// 标签字体大小
#define LabelFontSize				12.0f
// 标签离右边间距
#define SpatiumBetweenRightEdge		5.0f


@interface wordsCountView : UIView<UITextViewDelegate> {
	UILabel					*labelWord;     // 字数显示标签
	NSInteger				wordsNum;		// 剩余字数
    NSInteger               maxWords;       //能输入的最大字数个数
}

@property (nonatomic, strong) UILabel	*labelWord;
@property (nonatomic, assign) NSInteger	wordsNum;
@property (nonatomic, assign) NSInteger maxWords;
@property (nonatomic, weak) id          targetdelegate;//代理者
@property (nonatomic, weak) UITextField *targetField;  //目标文本输入框
@property (nonatomic, weak) UITextView  *targetTextview;
@property (nonatomic, assign) BOOL      iswordsOffset; //字数是否偏移
@end