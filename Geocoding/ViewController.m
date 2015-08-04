//
//  ViewController.m
//  Geocoding
//
//  Created by DEV MODE on 8/3/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // toga party
}

- (IBAction)findAddress:(id)sender {
    
}

- (IBAction)findLocation:(id)sender {
    //check to see if geocoder initialized, if not initialize it
    if (self.geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc]init];
    }
    NSString *address = self.inputText.text;
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark =[placemarks objectAtIndex:0];
            self.outputLabel.text = placemark.location.description;
        }
        else if (error.domain == kCLErrorDomain){
            switch (error.code) {
                case kCLErrorDenied:
                    self.outputLabel.text = @"Location Services Denied by User";
                    break;
                case kCLErrorNetwork:
                    self.outputLabel.text = @"No Network";
                    break;
                case kCLErrorGeocodeFoundNoResult:
                    self.outputLabel.text = @"No Result Found";
                    break;
                default:
                    self.outputLabel.text = error.localizedDescription;
                    break;
            }
        }
        else{
            self.outputLabel.text = error.localizedDescription;
        }
    }];
}
@end
