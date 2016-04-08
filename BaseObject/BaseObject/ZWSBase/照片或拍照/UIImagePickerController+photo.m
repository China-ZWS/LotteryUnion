//
//  UIImagePickerController+photo.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "UIImagePickerController+photo.h"

@implementation UIImagePickerController (photo)

+ (BOOL)isCameraAvailable;
{
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    return YES;
}

+ (BOOL)isPhotoLibraryAvailable;
{
    return [self isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

+ (BOOL)canTakePhoto;
{
    return [self isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
@end
