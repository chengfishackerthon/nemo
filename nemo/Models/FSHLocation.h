//
//  FSHLocation.h
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FSHLocation : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithLocation:(CLLocation *)location title:(NSString *)title;

@end
