//
//  FSHLocation.m
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHLocationManager.h"
#import "FSHLocation.h"

static const CGFloat kSpeedNotSet = -1.0;

@interface FSHLocationManager()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDistance totalDistance;
@property (nonatomic, strong) NSDate *startTimestamp;
@property (nonatomic) double currentSpeed;

@end

@implementation FSHLocationManager

+ (instancetype)sharedInstance {
    static FSHLocationManager *locationManagerSingleton = nil;
    static dispatch_once_t pred;

    dispatch_once(&pred, ^{
        locationManagerSingleton = [[FSHLocationManager alloc] init];
    });
    return locationManagerSingleton;
}

- (id)init {
    if ((self = [super init])) {
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        }

        [self resetLocationUpdates];
    }

    return self;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSMutableArray *)locationHistory
{
    if (!_locationHistory) {
        _locationHistory = [[NSMutableArray alloc] init];
    }
    return _locationHistory;
}

- (void)setTotalDistance:(CLLocationDistance)totalDistance {
    _totalDistance = totalDistance;

    if (self.currentSpeed != kSpeedNotSet) {
        if ([self.delegate respondsToSelector:@selector(locationManager:distanceUpdated:)]) {
            [self.delegate locationManager:self distanceUpdated:self.totalDistance];
        }
    }
}

- (NSTimeInterval)totalSeconds {
    return ([self.startTimestamp timeIntervalSinceNow] * -1);
}

- (void)requestNewLocation {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

- (BOOL)initLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationHistory removeAllObjects];
        self.currentSpeed = kSpeedNotSet;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];

        return YES;
    } else {
        return NO;
    }
}

- (BOOL)startLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {

        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];

        return YES;
    } else {
        return NO;
    }
}

- (void)stopLocationUpdates {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    self.locationManager = nil;
    self.locationManager.delegate = nil;
}

- (void)resetLocationUpdates {
    self.totalDistance = 0;
    self.startTimestamp = [NSDate dateWithTimeIntervalSinceNow:0];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    FSHLocation *location = [[FSHLocation alloc] initWithLocation:newLocation title:[NSString stringWithFormat:@"time: %@",  newLocation.timestamp]];
    [self.locationHistory addObject:location];

    NSLog(@"location manager didupdatetolocation %@", newLocation);
    if ([self.delegate respondsToSelector:@selector(locationManager:waypoint:calculatedSpeed:)]) {
        [self.delegate locationManager:self waypoint:newLocation calculatedSpeed:self.currentSpeed];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        if ([self.delegate respondsToSelector:@selector(locationManager:error:)]) {
            [self.delegate locationManager:self error:error];
        }
        [self stopLocationUpdates];
    }
}

@end
