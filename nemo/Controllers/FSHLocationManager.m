//
//  FSHLocation.m
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHLocationManager.h"
#import "FSHLocation.h"

static const NSUInteger kDistanceAndSpeedCalculationInterval = 3; // the interval (seconds) at which we calculate the user's distance and speed
static const NSUInteger kMinimumLocationUpdateInterval = 10; // the interval (seconds) at which we ping for a new location if we haven't received one yet
static const NSUInteger kNumLocationHistoriesToKeep = 20; // the number of locations to store in history so that we can look back at them and determine which is most accurate
static const NSUInteger kValidLocationHistoryDeltaInterval = 3; // the maximum valid age in seconds of a location stored in the location history
static const NSUInteger kMinLocationsNeededToUpdateDistanceAndSpeed = 3; // the number of locations needed in history before we will even update the current distance and speed
static const CGFloat kRequiredHorizontalAccuracy = 20.0; // the required accuracy in meters for a location.  if we receive anything above this number, the delegate will be informed that the signal is weak
static const CGFloat kMaximumAcceptableHorizontalAccuracy = 70.0; // the maximum acceptable accuracy in meters for a location.  anything above this number will be completely ignored

static const CGFloat kSpeedNotSet = -1.0;

@interface FSHLocationManager()

@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) NSTimer *locationPingTimer;
//@property (nonatomic, strong) CLLocation *lastRecordedLocation;
@property (nonatomic) CLLocationDistance totalDistance;
@property (nonatomic, strong) NSDate *startTimestamp;
@property (nonatomic) double currentSpeed;
//@property (nonatomic) NSUInteger lastDistanceAndSpeedCalculation;
//@property (nonatomic) BOOL forceDistanceAndSpeedCalculation;
//@property (nonatomic) NSTimeInterval pauseDelta;
//@property (nonatomic) NSTimeInterval pauseDeltaStart;
//@property (nonatomic) BOOL readyToExposeDistanceAndSpeed;
//@property (nonatomic) BOOL checkingSignalStrength;
//@property (nonatomic) BOOL allowMaximumAcceptableAccuracy;

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
//            self.locationManager.distanceFilter = kDistanceFilter;
//            self.locationManager.headingFilter = kHeadingFilter;
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
//    return ([self.startTimestamp timeIntervalSinceNow] * -1) - self.pauseDelta;
    return ([self.startTimestamp timeIntervalSinceNow] * -1);
}

- (void)requestNewLocation {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

- (BOOL)initLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationHistory removeAllObjects];
//        self.lastDistanceAndSpeedCalculation = 0;
        self.currentSpeed = kSpeedNotSet;
//        self.readyToExposeDistanceAndSpeed = NO;
//        self.allowMaximumAcceptableAccuracy = NO;

//        self.forceDistanceAndSpeedCalculation = YES;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];

        return YES;
    } else {
        return NO;
    }
}

- (BOOL)startLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
//        self.readyToExposeDistanceAndSpeed = YES;

        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];

//        if (self.pauseDeltaStart > 0) {
//            self.pauseDelta += ([NSDate timeIntervalSinceReferenceDate] - self.pauseDeltaStart);
//            self.pauseDeltaStart = 0;
//        }

        return YES;
    } else {
        return NO;
    }
}

- (void)stopLocationUpdates {
//    [self.locationPingTimer invalidate];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
//    self.pauseDeltaStart = [NSDate timeIntervalSinceReferenceDate];
//    self.lastRecordedLocation = nil;
    self.locationManager = nil;
    self.locationManager.delegate = nil;
}

- (void)resetLocationUpdates {
    self.totalDistance = 0;
    self.startTimestamp = [NSDate dateWithTimeIntervalSinceNow:0];
//    self.forceDistanceAndSpeedCalculation = NO;
//    self.pauseDelta = 0;
//    self.pauseDeltaStart = 0;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"location manager didupdatetolocation %@", newLocation);
    // since the oldLocation might be from some previous use of core location, we need to make sure we're getting data from this run
//    if (oldLocation == nil) return;
//    BOOL isStaleLocation = ([oldLocation.timestamp compare:self.startTimestamp] == NSOrderedAscending);

//    [self.locationPingTimer invalidate];

//    double horizontalAccuracy;
//    if (self.allowMaximumAcceptableAccuracy) {
//        horizontalAccuracy = kMaximumAcceptableHorizontalAccuracy;
//    } else {
//        horizontalAccuracy = kRequiredHorizontalAccuracy;
//    }

//    if (!isStaleLocation && newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy <= horizontalAccuracy) {

        FSHLocation *location = [[FSHLocation alloc] initWithLocation:newLocation title:[NSString stringWithFormat:@"time: %@",  newLocation.timestamp]];
        [self.locationHistory addObject:location];
//        if ([self.locationHistory count] > kNumLocationHistoriesToKeep) {
//            [self.locationHistory removeObjectAtIndex:0];
//        }

//        BOOL canUpdateDistanceAndSpeed = NO;
//        if ([self.locationHistory count] >= kMinLocationsNeededToUpdateDistanceAndSpeed) {
//            canUpdateDistanceAndSpeed = YES && self.readyToExposeDistanceAndSpeed;
//        }
//
//        if (self.forceDistanceAndSpeedCalculation || [NSDate timeIntervalSinceReferenceDate] - self.lastDistanceAndSpeedCalculation > kDistanceAndSpeedCalculationInterval) {
//            self.forceDistanceAndSpeedCalculation = NO;
//            self.lastDistanceAndSpeedCalculation = [NSDate timeIntervalSinceReferenceDate];

//            CLLocation *lastLocation = (self.lastRecordedLocation != nil) ? self.lastRecordedLocation : oldLocation;

//            CLLocation *bestLocation = nil;
//            CGFloat bestAccuracy = kRequiredHorizontalAccuracy;
            for (FSHLocation *fshLocation in self.locationHistory) {
                CLLocation *location = fshLocation.location;
//                if ([NSDate timeIntervalSinceReferenceDate] - [location.timestamp timeIntervalSinceReferenceDate] <= kValidLocationHistoryDeltaInterval) {
//                    if (location.horizontalAccuracy <= bestAccuracy && location != lastLocation) {
//                        bestAccuracy = location.horizontalAccuracy;
//                        bestLocation = location;
//                    }
//                }
            }
//            if (bestLocation == nil) bestLocation = newLocation;

//            CLLocationDistance distance = [bestLocation distanceFromLocation:lastLocation];
//            if (canUpdateDistanceAndSpeed) self.totalDistance += distance;
//            self.lastRecordedLocation = bestLocation;

            NSLog(@"location manager didupdatetolocation %@", newLocation);
            if ([self.delegate respondsToSelector:@selector(locationManager:waypoint:calculatedSpeed:)]) {
                [self.delegate locationManager:self waypoint:newLocation calculatedSpeed:self.currentSpeed];
            }
//        }
//    }

    // this will be invalidated above if a new location is received before it fires
//    self.locationPingTimer = [NSTimer timerWithTimeInterval:kMinimumLocationUpdateInterval target:self selector:@selector(requestNewLocation) userInfo:nil repeats:NO];
//    [[NSRunLoop mainRunLoop] addTimer:self.locationPingTimer forMode:NSRunLoopCommonModes];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
//    // we don't really care about the new heading.  all we care about is calculating the current distance from the previous distance early if the user changed directions
//    self.forceDistanceAndSpeedCalculation = YES;
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        if ([self.delegate respondsToSelector:@selector(locationManager:error:)]) {
            [self.delegate locationManager:self error:error];
        }
        [self stopLocationUpdates];
    }
}

@end
