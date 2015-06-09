//
//  Theater.h
//  RottenMangoes
//
//  Created by JIAN WANG on 5/28/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Theater : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) double distanceFromCurrentLocation;

-(instancetype)initWithName:(NSString *)name andAddress:(NSString *)address andLatitude:(float)latitude andLongitude:(float)longitude;

@end
