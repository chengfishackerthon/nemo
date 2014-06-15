//
//  FSHCatchInfoViewController.h
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FSHLocationManager.h"
#import "FSHSelectLocationViewController.h"
#import "FSHVessel.h"

@interface FSHCatchInfoViewController : UIViewController <FSHLocationManagerDelegate, MKMapViewDelegate, FSHSelectLocationViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) FSHVessel *vessel;
@property (strong, nonatomic) id<FSHSelectLocationViewControllerDelegate> delegate;

- (IBAction)submit:(id)sender;
- (IBAction)getLocation:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
