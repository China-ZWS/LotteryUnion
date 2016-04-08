//
//  UIDevice+IdentifierAddition.m
//  BaseLibrary
//
//  Created by xhd945 on 16/1/15.
//  Copyright © 2016年 xhd945. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"
#import "UUIDManager.h"

@implementation UIDevice (IdentifierAddition)
- (NSString *) uniqueDeviceIdentifier
{
    
    
    NSString *uuid = [UUIDManager readUuID];
     
    if (uuid != nil && uuid.length != 0 )
    {
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        NSString *stringToHash = [NSString stringWithFormat:@"%@%@",uuid,bundleIdentifier];
        NSString *uniqueIdentifier = [stringToHash stringFromMD5:@""];
        return uniqueIdentifier;

    }
    return nil;
}

@end
