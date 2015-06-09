//
//  MyUser.m
//  RottenMangoes
//
//  Created by JIAN WANG on 6/8/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "MyUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation MyUser

@dynamic userType;
@dynamic imageFile;
@dynamic favoriteMovies;

+ (MyUser *)currentUser {
    return (MyUser *)[PFUser currentUser];
}

+ (void)load {
    [self registerSubclass];
}

@end
