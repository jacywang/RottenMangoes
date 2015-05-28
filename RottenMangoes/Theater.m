//
//  Theater.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/28/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "Theater.h"

@implementation Theater

-(instancetype)initWithName:(NSString *)name andAddress:(NSString *)address andLatitude:(float)latitude andLongitude:(float)longitude {
    self = [super init];
    if (self) {
        _name = name;
        _address = address;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

@end
