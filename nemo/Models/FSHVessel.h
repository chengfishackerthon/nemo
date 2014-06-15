//
//  FSHVessel.h
//  nemo
//
//  Created by t on 6/15/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSHVessel : NSObject

@property (strong, nonatomic) NSString *vesselID;
@property (strong, nonatomic) NSString *engine;
@property (strong, nonatomic) NSString *hp;
@property (strong, nonatomic) NSString *length;
@property (strong, nonatomic) NSString *width;
@property (strong, nonatomic) NSString *height;

- (instancetype)initWithVesselID:(NSString *)vesselID;

@end
