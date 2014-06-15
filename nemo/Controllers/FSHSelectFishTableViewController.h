//
//  FSHSelectFishTableViewController.h
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHMapAnnotation.h"

@interface FSHSelectFishTableViewController : UITableViewController

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSMutableArray *selection;

@end
