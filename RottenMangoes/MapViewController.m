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
#import "TableViewCell.h"

@interface MapViewController () {
    CLLocationManager *_locationManager;
    CLLocation *_userLocation;
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
    self.mapView.mapType = MKMapTypeStandard;
    
    _userLocation = [[CLLocation alloc] init];
}

- (IBAction)segmentControlClicked:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
    }
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
                    theater.distanceFromCurrentLocation = [_userLocation distanceFromLocation:theater.location];
                    [self.theaterList addObject:theater];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (Theater *theater in self.theaterList) {
                        [self addAnnotationforTheater:theater];
                    }
                    
                    [self.theaterList sortUsingComparator:^NSComparisonResult(Theater *obj1, Theater *obj2) {
                        if (obj1.distanceFromCurrentLocation > obj2.distanceFromCurrentLocation) {
                            return NSOrderedDescending;
                        }
                        if (obj1.distanceFromCurrentLocation < obj2.distanceFromCurrentLocation) {
                            return NSOrderedAscending;
                        }
                        return NSOrderedSame;
                    }];
                    
                    [self.tableView reloadData];
                });
                
                
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

-(UIImage *)getPinViewByTitle:(MKPointAnnotation *)annotation {
    NSArray *pinImageArray = @[[UIImage imageNamed:@"pin0"],
                               [UIImage imageNamed:@"pin1"],
                               [UIImage imageNamed:@"pin2"],
                               [UIImage imageNamed:@"pin3"],
                               [UIImage imageNamed:@"pin4"],
                               [UIImage imageNamed:@"pin5"],
                               [UIImage imageNamed:@"pin6"],
                               [UIImage imageNamed:@"pin7"],
                               [UIImage imageNamed:@"pin8"],
                               [UIImage imageNamed:@"pin9"],
                               [UIImage imageNamed:@"pin10"],
                               [UIImage imageNamed:@"pin11"]
                               ];
    if ([annotation.title containsString:@"AMC"]) {
        return pinImageArray[0];
    } else if ([annotation.title containsString:@"CineArts"]) {
        return pinImageArray[1];
    } else if ([annotation.title containsString:@"Century"]) {
        return pinImageArray[2];
    } else if ([annotation.title containsString:@"CineLux"]) {
        return pinImageArray[3];
    } else if ([annotation.title containsString:@"Camera"]) {
        return pinImageArray[4];
    } else if ([annotation.title containsString:@"Los Gatos"]) {
        return pinImageArray[5];
    } else if ([annotation.title containsString:@"BlueLight"]) {
        return pinImageArray[6];
    }
    return nil;
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
    
    pinView.image = [self getPinViewByTitle:annotation];
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.calloutOffset = CGPointMake(-15, 0);
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
    _userLocation = [locations firstObject];
    
    if (!_isInitialLocationSet) {
        MKCoordinateRegion region;
        region.center = _userLocation.coordinate;
        region.span.latitudeDelta = 0.1;
        region.span.longitudeDelta = 0.1;
        
        [self.mapView setRegion:region animated:YES];
        self.theaterList = [[NSMutableArray alloc] init];

        _isInitialLocationSet = YES;
    
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:_userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placeMark = [placemarks firstObject];
            _postCode = placeMark.postalCode;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadTheater];
            });
            
        }];
    
    }
}

#pragma mark - TableViewDataSource and TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.theaterList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"theaterCell" forIndexPath:indexPath];
    Theater *theater = self.theaterList[indexPath.row];
    cell.nameLabel.text = theater.name;
    cell.addressLabel.text = theater.address;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.0fm", theater.distanceFromCurrentLocation];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Theater *selectedTheater = self.theaterList[indexPath.row];
    
    MKCoordinateRegion region;
    region.center = _userLocation.coordinate;
    region.span.latitudeDelta = (selectedTheater.distanceFromCurrentLocation * 2 + 1000) / 110000;
    region.span.longitudeDelta = (selectedTheater.distanceFromCurrentLocation * 2 + 1000) / 110000;
    
    [self.mapView setRegion:region animated:YES];
}

@end
