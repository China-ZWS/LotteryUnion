//
//  GPS_Location.m
//  MoodMovie
//
//  Created by 周文松 on 14-8-6.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//



#import "GPS_Location.h"


@implementation GPS_Location


- (id) init
{
    if (self = [super init])
    {
        
        _location_manager = [[CLLocationManager alloc] init];
        [self.location_manager setDelegate:self];
        [self.location_manager setDesiredAccuracy:kCLLocationAccuracyBest];
        self.location_manager.distanceFilter = 1;
    }
    
	return self;
}

//开始定位
- (void) startingGpsLocation
{
    [self.location_manager startUpdatingLocation];
}

//停止定位
- (void) stopGpsLocation
{
    [self.location_manager stopUpdatingLocation];
}

//定位失败
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_delegate willGetLocationError:error];
    return ;
}


//定位数据
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    [self stopGpsLocation];
    //    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    //        for (CLPlacemark * placemark in placemarks) {
    //
    //            NSDictionary *test = [placemark addressDictionary];
    //            //  Country(国家)  State(城市)  SubLocality(区)
    //
    //        }
    //    }];
    
    
    if (_delegate != nil)
    {
        [self.delegate willGPSGetLocation:newLocation oldLocation:oldLocation];
    }
}


-(void)dealloc
{
}

@end

