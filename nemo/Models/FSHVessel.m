//
//  FSHVessel.m
//  nemo
//
//  Created by t on 6/15/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHVessel.h"

@implementation FSHVessel

- (instancetype)initWithVesselID:(NSString *)vesselID
{
    self = [super init];
    if (self) {
        _vesselID = vesselID;
    }
    return self;
}

@end
