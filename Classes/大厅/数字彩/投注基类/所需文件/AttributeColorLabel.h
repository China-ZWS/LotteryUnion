//
//  PDKeyColorLabel.h
//
//  Created by liuchan on 12-8-22.
//
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface AttributeColorLabel : OHAttributedLabel
{
}

@property (nonatomic) NSMutableArray *textArray;

-(void)addText:(NSString*)text color:(UIColor*)color font:(UIFont*)font;
-(void)clearText;
-(NSString*)drawColorString;

+(NSAttributedString*)buildAttrString:(NSArray*)textArray font:(UIFont*)defFont color:(UIColor*)defColor;
+(void)addText:(NSString *)text color:(UIColor *)color font:(UIFont *)font toArray:(NSMutableArray*)tArray;

@end
