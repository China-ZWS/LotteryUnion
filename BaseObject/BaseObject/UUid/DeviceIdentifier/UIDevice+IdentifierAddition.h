//
//  UIDevice+IdentifierAddition.h
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//
#import <UIKit/UIKit.h>

/**
 *  获取设备的统一标示符
 */

@interface UIDevice (IdentifierAddition)

- (NSString *) uniqueDeviceIdentifier;

@end
