//
//  FSHViewController.m
//  nemo
//
//  Created by t on 6/13/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import "FSHViewController.h"
#import "FSHCatchInfoViewController.h"

@interface FSHViewController ()

@property (weak, nonatomic) IBOutlet UITextField *vesselID;
@property (weak, nonatomic) IBOutlet UITextField *engine;
@property (weak, nonatomic) IBOutlet UITextField *hp;
@property (weak, nonatomic) IBOutlet UITextField *length;
@property (weak, nonatomic) IBOutlet UITextField *width;
@property (weak, nonatomic) IBOutlet UITextField *height;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *activeField;

@end

@implementation FSHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self registerForKeyboardNotifications];
    [self setTextFieldDelegates];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toCatchInfo"]) {
        FSHCatchInfoViewController *destination = segue.destinationViewController;

        FSHVessel *vessel = [[FSHVessel alloc] initWithVesselID:self.vesselID.text];
        
        destination.vessel = vessel;
    }

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

// Called when the UIKeyboardDidShowNotification is sent.
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
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
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
