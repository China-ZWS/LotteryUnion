//
//  BaseMsgPlaySound.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-20.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>  
@interface BaseMsgPlaySound : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}
- (id)initSystemShake;//系统 震动
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
- (void)play;//播放
@end

