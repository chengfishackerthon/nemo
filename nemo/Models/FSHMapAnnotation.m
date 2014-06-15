//
//  FSHMapAnnotation.m
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHMapAnnotation.h"

@implementation FSHMapAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate description:(NSString *)description
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _description = [description copy];

    }
    return self;
}

-(NSString *)title
{
    return self.description;
}

@end
