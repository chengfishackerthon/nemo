//
//  FSHLocation.m
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHLocation.h"

@implementation FSHLocation

- (instancetype)initWithLocation:(CLLocation *)location title:(NSString *)title
{
    self = [super init];
    if (self) {
        _location = location;
        _title = title;
    }
    return self;
}

@end
