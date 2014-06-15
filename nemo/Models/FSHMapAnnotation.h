//
//  FSHMapAnnotation.h
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FSHMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *description;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate description:(NSString *)description;

@end
