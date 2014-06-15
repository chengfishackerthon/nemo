//
//  FSHSelectLocationViewController.h
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol FSHSelectLocationViewControllerDelegate

- (void)receiveData:(MKPointAnnotation *)data;

@end

@interface FSHSelectLocationViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPolyline *routeLine; //your line
@property (nonatomic, strong) MKPolylineView *routeLineView; //overlay view
@property (nonatomic, strong) MKPointAnnotation *point;
@property id<FSHSelectLocationViewControllerDelegate>delegate;

- (IBAction)mapSelect:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)confirm:(id)sender;

@end
