//
//  GPS_Location.h
//  MoodMovie
//
//  Created by 周文松 on 14-8-6.
//  Copyright (c) 2014年 com.talkweb.MoodMovie. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@protocol GPS_LocationDelegate <NSObject>

- (void) willGPSGetLocation:(CLLocation *)newLocation oldLocation:(CLLocation *)oldLocation;
- (void) willGetLocationError : (NSError *)error;

@end

@interface GPS_Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *location_manager;
@property(strong,nonatomic) id <GPS_LocationDelegate> delegate;

- (void) startingGpsLocation;

- (void) stopGpsLocation;

@end
