//
//  ToolSingleton.m
//  MoodMovie
//
//  Created by 周文松 on 14-8-31.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import "ToolSingleton.h"
#define kUserDefaults [NSUserDefaults standardUserDefaults]
@implementation ToolSingleton


static ToolSingleton *instance = nil;//第一步：静态实例，并初始化。

+ (ToolSingleton*) getInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (instance == nil)
        {
 
            instance = [[self alloc] init];
    
        }
    }
    return instance;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法 //防止碎片化
{
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

# pragma mark - 读取城市文件
- (void)readWithListOfCities;
{
    NSString *cityFilePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    NSStringEncoding *usedEncoding=nil;
    NSString *strFileContent=[NSString stringWithContentsOfFile:cityFilePath usedEncoding:usedEncoding error:nil];
    if(!strFileContent)
    {
        strFileContent=[NSString stringWithContentsOfFile:cityFilePath encoding:0x80000632 error:nil];
    }
    else if(!strFileContent)
    {
        strFileContent=[NSString stringWithContentsOfFile:cityFilePath encoding:0x80000631 error:nil];
    }
    if(!strFileContent)
    {
        NSLog(@"%@文件 找不到",cityFilePath);
    }
    else
    {
        NSData *data = [strFileContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dicPar=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *aryUSUALCITYS=[dicPar objectForKey:@"USUALCITYS"];//普通城市
        NSMutableArray *keys = [NSMutableArray array];
        for (NSDictionary *dict in aryUSUALCITYS)
        {
            NSString *pingcode = dict[@"PINGCODE"];
            if(![keys containsObject:pingcode])
            {
                [keys addObject:pingcode];
            }
        }
        
        NSMutableDictionary *mdicName = [NSMutableDictionary dictionary];
        for (NSString *key in keys)
        {
            NSArray *aryTmp=[aryUSUALCITYS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"PINGCODE == %@",key]];
            mdicName[key] = aryTmp;
        }
        self.keys = keys;
        self.name = mdicName;
    }
}


#pragma mark 定位获取经纬度
- (void)startingGpsLocation;
{
    self.gps_location = [[GPS_Location alloc]init];
    self.gps_location.delegate = self;
    [self.gps_location startingGpsLocation];

}


- (void) willGPSGetLocation:(CLLocation *)newLocation oldLocation:(CLLocation *)oldLocation
{

    self.lastCity = [kUserDefaults objectForKey:@"cityName"];
    self.cityCode = [kUserDefaults objectForKey:@"cityCode"];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            self.lastCity = [test objectForKey:@"City"];
//            [[test objectForKey:@"City"] stringByReplacingOccurrencesOfString:@"市" withString:@""];
            self.cityCode = [self getCityCode];
            
            
            [kUserDefaults setValue:[NSString stringWithFormat:@"%@",self.lastCity] forKey:@"cityName"];
            [kUserDefaults setValue:[NSString stringWithFormat:@"%@",self.cityCode] forKey:@"cityCode"];
            [kUserDefaults synchronize];

        }
    }];

    
    self.longitudes = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    self.latitudes = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
 
    
    return ;
}

- (NSString *)getCityCode
{
    NSString *cityFilePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    NSStringEncoding *usedEncoding=nil;
    NSString *strFileContent=[NSString stringWithContentsOfFile:cityFilePath usedEncoding:usedEncoding error:nil];
    if(!strFileContent)
    {
        strFileContent=[NSString stringWithContentsOfFile:cityFilePath encoding:0x80000632 error:nil];
    }
    else if(!strFileContent)
    {
        strFileContent=[NSString stringWithContentsOfFile:cityFilePath encoding:0x80000631 error:nil];
    }
    if(!strFileContent)
    {
        NSLog(@"%@文件 找不到",cityFilePath);
    }
    else
    {
        NSData *data = [strFileContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dicPar=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *aryUSUALCITYS=[dicPar objectForKey:@"USUALCITYS"];//普通城
        
        for (NSDictionary * cityDict in aryUSUALCITYS)
        {
            if ([cityDict[@"CITYNAME"] isEqualToString:_lastCity])
            {
                return cityDict[@"CITYCODE"];
                break;
            }
        }
    }
    return nil;
}


- (void) willGetLocationError:(NSError *)error
{
    self.gps_location.delegate = nil;
    [self.gps_location stopGpsLocation];
    return ;
}
/**gps end**/


#pragma mark - 网络监控
- (void)createNetworkSniffer
{
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    
    _hostReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];//可以以多种形式初始化
    [_hostReach startNotifier];  //开始监听,会启动一个run loop

}

- (void)reachabilityChanged:(NSNotification *)note
{
    
    Reachability * curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{

    switch ([curReach currentReachabilityStatus])
    {
        case NotReachable:
        {
            if(self.delegate&&[self.delegate respondsToSelector:@selector(reloadDatas:)]){
                [self.delegate reloadDatas:NotReachable];
            }
        }
            // 没有网络连接
            break;
        case ReachableViaWWAN:
        {
            if(self.delegate&&[self.delegate respondsToSelector:@selector(reloadDatas:)]){
                [self.delegate reloadDatas:ReachableViaWWAN];
            }
        }
            break;
        case ReachableViaWiFi:
        {
            if(self.delegate&&[self.delegate respondsToSelector:@selector(reloadDatas:)]){
                [self.delegate reloadDatas:ReachableViaWiFi];
            }
        }
            // 使用WiFi网络
            break;
    }
    
    
}


#pragma mark
#pragma mark 声音监听
-(void)createSoundMonitor
{
    //.....    //声音监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)volumeChanged:(NSNotification *)notification
{
    self.volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
//    FunctionSingleton *instance = [FunctionSingleton getInstance];
//    instance.data.value = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
}



@end
