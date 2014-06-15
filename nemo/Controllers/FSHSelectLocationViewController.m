//
//  FSHSelectLocationViewController.m
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHSelectLocationViewController.h"
#import "FSHLocationManager.h"
#import "FSHMapAnnotation.h"
#import "FSHLocation.h"

@interface FSHSelectLocationViewController ()

@property (nonatomic, strong) FSHLocationManager *locationManager;

@end

@implementation FSHSelectLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.mapView.delegate = self;
    CLLocationCoordinate2D coordinates[[self.locationManager.locationHistory count]];
    NSLog(@"FSHSelectLocation %@", self.locationManager.locationHistory);
    for (int i=0; i < [self.locationManager.locationHistory count]; i++) {
//        FSHLocation *preWaypoint = nil;
        FSHLocation *waypoint = self.locationManager.locationHistory[i];
        if (i == 0) {
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = waypoint.location.coordinate.latitude;
            coordinate.longitude = waypoint.location.coordinate.longitude;
            MKCoordinateRegion region;
            region.center = coordinate;

            MKCoordinateSpan span;
            span.latitudeDelta = 0.2;
            span.longitudeDelta = 0.2;
            region.span = span;

            [self.mapView setRegion:region animated:YES];
        } else {
//            preWaypoint = self.locationManager.locationHistory[i-1];
        }
        FSHMapAnnotation *annotation = [[FSHMapAnnotation alloc] initWithCoordinate:waypoint.location.coordinate description:[NSString stringWithFormat:@"%d: %@", i+1, waypoint.title]];
//        [self.mapView removeAnnotations:self.mapView.annotations];
//        [self.mapView addAnnotation:annotation];

//        if (preWaypoint) {
//            CLLocationCoordinate2D coordinateArray[2];
//            coordinateArray[0] = CLLocationCoordinate2DMake(preWaypoint.location.coordinate.latitude, preWaypoint.location.coordinate.longitude);
//            coordinateArray[1] = CLLocationCoordinate2DMake(waypoint.location.coordinate.latitude, waypoint.location.coordinate.longitude);
//
//            MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
//            [self.mapView setVisibleMapRect:[routeLine boundingMapRect]]; //If you want the route to be visible
//
//            [self.mapView addOverlay:routeLine];
//        }
        coordinates[i] = CLLocationCoordinate2DMake(waypoint.location.coordinate.latitude, waypoint.location.coordinate.longitude);
    }

    MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinates count:[self.locationManager.locationHistory count]];

    [self.mapView addOverlay:routeLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (FSHLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [FSHLocationManager sharedInstance];
    }
    return _locationManager;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [view setCanShowCallout:YES];
    NSLog(@"Title:%@",[view.annotation description]);

    self.point.coordinate = [view.annotation coordinate];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location saved"
                                                    message:@"You location has been saved"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *mapOverlayView = [[MKPolylineView alloc] initWithPolyline:overlay];
        //add autorelease if not using ARC
        mapOverlayView.strokeColor = [UIColor greenColor];
        mapOverlayView.lineWidth = 10;
                NSLog(@"overlay %@", mapOverlayView);
        return mapOverlayView;
    }
    
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (MKPointAnnotation *)point
{
    if (!_point) {
        _point = [[MKPointAnnotation alloc] init];
    }
    return _point;
}

- (IBAction)mapSelect:(id)sender {
    //if (self.point.) return;
    CGPoint point = [sender locationInView:self.mapView];

    CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    self.point.coordinate = tapPoint;

    [self.mapView addAnnotation:self.point];
}

- (IBAction)reset:(id)sender {
    [self.mapView removeAnnotation:self.point];
}

- (IBAction)confirm:(id)sender {
    [self.delegate receiveData:self.point];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
