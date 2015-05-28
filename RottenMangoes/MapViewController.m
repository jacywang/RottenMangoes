//
//  MapViewController.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/28/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "MapViewController.h"
#import "Theater.h"
#import "Movie.h"

@interface MapViewController () {
    CLLocationManager *_locationManager;
    BOOL _isInitialLocationSet;
    NSString *_postCode;
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

-(void)loadTheater {
    NSString *urlString = [[[@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=" stringByAppendingString:_postCode] stringByAppendingString:@"&movie="] stringByAppendingString:[self.movie.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                for (NSDictionary *item in dict[@"theatres"]) {
                    Theater *theater = [[Theater alloc] initWithName:item[@"name"] andAddress:item[@"address"] andLatitude:[item[@"lat"] floatValue] andLongitude:[item[@"lng"] floatValue]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addAnnotationforTheater:theater];
                    });
                }
                
            } else {
                NSLog(@"%ld", (long)httpResponse.statusCode);
            }
        } else {
            NSLog(@"%@", [error.userInfo valueForKey:@"error"]);
        }
        
    }];
    [task resume];
}

-(void)addAnnotationforTheater:(Theater *)theater {
    MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D theaterLocation;
    theaterLocation.latitude = theater.latitude;
    theaterLocation.longitude = theater.longitude;
    marker.coordinate = theaterLocation;
    marker.title = theater.name;
    
    [self.mapView addAnnotation:marker];
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    static NSString *annotationIdentifier = @"theaterLocation";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    }
    
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.calloutOffset = CGPointMake(-15, 0);
    
    return pinView;
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    
    if (!_isInitialLocationSet) {
        MKCoordinateRegion region;
        region.center = location.coordinate;
        region.span.latitudeDelta = 0.1;
        region.span.longitudeDelta = 0.1;
        
        [self.mapView setRegion:region animated:YES];
        _isInitialLocationSet = YES;
    }
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        _postCode = placeMark.postalCode;
        [self loadTheater];
    }];
}

@end
