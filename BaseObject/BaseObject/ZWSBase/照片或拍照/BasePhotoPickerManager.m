//
//  BasePhotoPickerManager.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BasePhotoPickerManager.h"
#import "UIImagePickerController+Photo.h"

@interface BasePhotoPickerManager ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate>
{
}
@property (nonatomic, weak)     UIViewController          *fromController;
@property (nonatomic, copy)     PickerCompelitionBlock completion;
@property (nonatomic, copy)     PickerCancelBlock      cancelBlock;



@end
@implementation BasePhotoPickerManager

+ (BasePhotoPickerManager *)shared {
    static BasePhotoPickerManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    
    return sharedObject;
}


- (void)showActionSheetInView:(UIView *)inView
               fromController:(UIViewController *)fromController
                   completion:(PickerCompelitionBlock)completion
                  cancelBlock:(PickerCancelBlock)cancelBlock {
    self.completion = [completion copy];
    self.cancelBlock = [cancelBlock copy];
    self.fromController = fromController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActionSheet *actionSheet = nil;
        if ([UIImagePickerController isCameraAvailable])
        {
            actionSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照上传", nil];
        }
        else
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [actionSheet showInView:inView];  
        });  
    });  
    
    return;  
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // 从相册选择
        if ([UIImagePickerController isPhotoLibraryAvailable]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            
//            picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;
//            // 设置导航默认标题的颜色及字体大小
//            picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }
    } else if (buttonIndex == 1) { // 拍照
        if ([UIImagePickerController canTakePhoto]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;

            [self.fromController presentViewController:picker animated:YES completion:nil];
        }  
    }  
    return;  
}

#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (image && self.completion) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completion(image);
            });  
        });  
    }  
    return;  
}  

// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.cancelBlock) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.cancelBlock();
    }
    return;  
}

@end
