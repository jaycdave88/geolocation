//
//  ViewController.h
//  Geocoding
//
//  Created by DEV MODE on 8/3/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
- (IBAction)findAddress:(id)sender;
- (IBAction)findLocation:(id)sender;
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

