//
//  FSHLocation.h
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class FSHLocationManager;

@protocol FSHLocationManagerDelegate <NSObject>

- (void)locationManager:(FSHLocationManager *)location waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed;

@optional
- (void)locationManager:(FSHLocationManager *)location distanceUpdated:(CLLocationDistance)distance;
- (void)locationManager:(FSHLocationManager *)location error:(NSError *)error;
//- (void)locationManager:(FSHLocationManager *)location debugText:(NSString *)text;

@end

@interface FSHLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<FSHLocationManagerDelegate> delegate;
@property (nonatomic, readonly) CLLocationDistance totalDistance;
@property (nonatomic, readonly) NSTimeInterval totalSeconds;
@property (nonatomic, readonly) double currentSpeed;
@property (nonatomic, strong) NSMutableArray *locationHistory;

+ (instancetype)sharedInstance;

- (BOOL)initLocationUpdates;
- (BOOL)startLocationUpdates;
- (void)stopLocationUpdates;
- (void)resetLocationUpdates;

@end
