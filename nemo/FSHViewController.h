//
//  FSHViewController.h
//  nemo
//
//  Created by t on 6/13/14.
//  Copyright (c) 2014 Fishackathon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSHViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *vesselID;
@property (weak, nonatomic) IBOutlet UITextField *engine;
@property (weak, nonatomic) IBOutlet UITextField *hp;
@property (weak, nonatomic) IBOutlet UITextField *length;
@property (weak, nonatomic) IBOutlet UITextField *width;
@property (weak, nonatomic) IBOutlet UITextField *height;
@property (weak, nonatomic) IBOutlet UIButton *submit;

@end
