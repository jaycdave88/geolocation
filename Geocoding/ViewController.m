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
    _locationManager = [[CLLocationManager alloc] init];
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

- (IBAction)findAddress:(id)sender {
    if([CLLocationManager locationServicesEnabled]){
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.distanceFilter = 300;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.delegate = self;
        }

        [_locationManager startUpdatingLocation];
        self.outputLabel.text = @"Getting location...";
    } else{
        self.outputLabel.text = @"Location Services Not Available";
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        self.outputLabel.text = @"Location information denied";
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation = [locations lastObject];
    NSTimeInterval eventInterval = [newLocation.timestamp timeIntervalSinceNow];
    if (abs(eventInterval)< 30.0) {
        if (newLocation.horizontalAccuracy < 0) {
            return;
        }

    }

    if (self.geocoder == nil) {
        self.geocoder =[[CLGeocoder alloc] init];
    }

    if ([self.geocoder isGeocoding]) {
        [self.geocoder cancelGeocode];
    }
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *foundPlacemark = [placemarks objectAtIndex:0];
            self.outputLabel.text = [NSString stringWithFormat:@"You are in: %@", foundPlacemark.description];
        }else if (error.code == kCLErrorGeocodeCanceled){
            NSLog(@"Geocoding cancelled");
        }else if (error.code == kCLErrorGeocodeFoundNoResult){
            self.outputLabel.text = @"No geocode result found";
        }else if (error.code == kCLErrorGeocodeFoundPartialResult){
            self.outputLabel.text = @"Partial geocode result";
        }else{
            self.outputLabel.text = [NSString stringWithFormat:@"Unknown error: %@", error.description];
        }
    }];
    [manager stopUpdatingLocation];
}




@end
