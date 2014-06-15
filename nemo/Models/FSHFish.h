//
//  FSHFish.h
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSHFish : NSObject

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *species;
@property (nonatomic, strong) NSString *family;
@property (nonatomic, strong) NSString *class;
@property (nonatomic, strong) NSString *firstOrder;
@property (nonatomic, strong) NSString *habitat;
@property (nonatomic, strong) NSString *length;
@property (nonatomic, strong) NSString *tropicLevel;

@end
