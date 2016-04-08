//
//  ToolSingleton.h
//  MoodMovie
//
//  Created by 周文松 on 14-8-31.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import "GPS_Location.h"
#import "Reachability.h"

@protocol ToolSingletonDelegate <NSObject>

@optional
- (void)reloadDatas:(NetworkStatus)status;

@end

@interface ToolSingleton : NSObject <GPS_LocationDelegate>
{
    GPS_Location *_gps_location;
    NSString *_longitudes;
    NSString *_latitudes;
    Reachability *_hostReach;
}

@property (nonatomic, weak) id<ToolSingletonDelegate>delegate;

+(ToolSingleton *)getInstance;

- (void)startingGpsLocation;
//gps
@property (nonatomic, strong) GPS_Location *gps_location;
@property (nonatomic, strong)  NSString *longitudes;
@property (nonatomic, strong)  NSString *latitudes;

@property (nonatomic, strong)  NSString *lastCity;
@property (nonatomic, strong)  NSString *cityCode;
@property (nonatomic, strong)  NSString *lastAddress;

//city
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSDictionary *name;
@property (nonatomic) float volume;


//读取城市文件
- (void)readWithListOfCities;
//网络监控
- (void)createNetworkSniffer;
// 声音
-(void)createSoundMonitor;


@end
