//
//  MapViewController.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/28/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () {
    CLLocationManager *_locationManager;
    BOOL _isInitialLocationSet;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isInitialLocationSet = NO;
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    _locationManager.desiredAccuracy = 500;
    _locationManager.distanceFilter = 50;
    _locationManager.delegate = self;
    
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations firstObject];
    
    if (!_isInitialLocationSet) {
        MKCoordinateRegion region;
        region.center = location.coordinate;
        region.span.latitudeDelta = 0.02;
        region.span.longitudeDelta = 0.02;
        
        [self.mapView setRegion:region animated:YES];
        _isInitialLocationSet = YES;
    }
    
    
}

@end
