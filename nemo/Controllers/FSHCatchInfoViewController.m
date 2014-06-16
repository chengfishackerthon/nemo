//
//  FSHCatchInfoViewController.m
//  nemo
//
//  Created by t on 6/14/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHCatchInfoViewController.h"
#import "FSHMapAnnotation.h"
#import "FSHSelectFishTableViewController.h"

static const NSString *kServer = @"http://172.16.1.126:9090";

@interface FSHCatchInfoViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) FSHLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UITextField *timestamp;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *fish;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (nonatomic, getter = shouldUpdateLocation) BOOL updateLocation;

@end

@implementation FSHCatchInfoViewController

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

    self.delegate = self;
    [self registerForKeyboardNotifications];
    [self setTextFieldDelegates];

//    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)setTextFieldDelegates
{
    for (UIView *subview in self.scrollView.subviews) {
        if ([subview isKindOfClass: [UITextView class]]) {
            ((UITextView*)subview).delegate = (id) self;
        }

        if ([subview isKindOfClass: [UITextField class]]) {
            ((UITextField*)subview).delegate = (id) self;
        }
    }
}
- (CLLocation *)location
{
    if (!_location) {
        _location = [[CLLocation alloc] init];
    }
    return _location;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)unwindFromModalViewController:(UIStoryboardSegue *)segue
{
    NSLog(@"unwind %@", [segue.sourceViewController class]);
    if ([segue.sourceViewController isKindOfClass:[FSHSelectFishTableViewController class]]) {
        FSHSelectFishTableViewController *selectFishTableViewController = segue.sourceViewController;
        if (selectFishTableViewController.selection) {
            NSLog(@"selection %@", selectFishTableViewController.selection);
            NSString *prefix = @"";
            for (int i=0; i<[selectFishTableViewController.selection count]; i++) {
                if (i > 0) {
                    prefix = @", ";
                }
                self.fish.text = [self.fish.text stringByAppendingFormat:@"%@%@", prefix, [selectFishTableViewController.selection[i] valueForKeyPath:@"Name"]];
            }
        }
    }
}

#pragma mark - FSHLocationManager

- (void)locationManager:(FSHLocationManager *)location waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed
{
    NSLog(@"way point %@", waypoint.description);
    NSLog(@"way points %@", location.locationHistory);
    self.location = waypoint;
    [self updateMap];
    [self.locationManager stopLocationUpdates];
}

- (void)updateMap
{
    if (self.shouldUpdateLocation) {
        self.latitude.text = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
        self.longitude.text = [NSString stringWithFormat:@"%f", self.location.coordinate.longitude];
        self.timestamp.text = [NSString stringWithFormat:@"%@", self.location.timestamp];

        CLLocationCoordinate2D coordinate;
        coordinate.latitude = self.location.coordinate.latitude;
        coordinate.longitude = self.location.coordinate.longitude;

        MKCoordinateRegion region;
        region.center = coordinate;

        MKCoordinateSpan span;
        span.latitudeDelta = 0.2;
        span.longitudeDelta = 0.2;
        region.span = span;

        [self.mapView setRegion:region animated:YES];

        FSHMapAnnotation *annotation = [[FSHMapAnnotation alloc] initWithCoordinate:coordinate description:nil];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:annotation];
        self.updateLocation = NO;
    }
}

#pragma mark - FSHSelctionLocationViewControllerDelegate

- (void)receiveData:(MKPointAnnotation *)data {

    NSLog(@"received data %@", data);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:data.coordinate.latitude longitude:data.coordinate.longitude];
    self.location = location;
    [self updateMap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toLocation"]) {
        FSHSelectLocationViewController *destination = segue.destinationViewController;
        destination.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"toFish"]) {
        FSHSelectFishTableViewController *destination =segue.destinationViewController;
        destination.location = self.location;
    }

}

+ (NSString *)urlEncode:(NSString *)string
{
    // Based on: http://stackoverflow.com/questions/2590545/urlencoding-a-string-with-objective-c
    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!’\"();:@&=+$,/?%#[]% ", kCFStringEncodingISOLatin1);
    return encodedString;
}

- (IBAction)submit:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/submit?latitude=%f&longitude=%f&vessel_id=%@&fishes=%@", kServer, self.location.coordinate.latitude, self.location.coordinate.longitude, [FSHCatchInfoViewController urlEncode:self.vessel.vesselID], [FSHCatchInfoViewController urlEncode:self.fish.text]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];

    [request setHTTPMethod: @"GET"];

    NSError *requestError;
    NSURLResponse *urlResponse = nil;


    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submitted"
                                                    message:@"Your request has been submitted"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // do stuff
    }
}

- (IBAction)getLocation:(id)sender {
    self.locationManager = [FSHLocationManager sharedInstance];
    [self.locationManager startLocationUpdates];
    self.locationManager.delegate = self;
    self.updateLocation = YES;
}

#pragma mark - keyboard notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (self.activeField) {
        if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
            [self.scrollView scrollRectToVisible:self.activeField.frame animated:NO];
            //[self.scrollView setContentOffset:self.activeField.frame.origin animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSLog(@"text field tag %ld", (long)textField.tag);
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
