//
//  UIImagePickerController+photo.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (photo)
+ (BOOL)isCameraAvailable;
+ (BOOL)isPhotoLibraryAvailable;
+ (BOOL)canTakePhoto;
@end
