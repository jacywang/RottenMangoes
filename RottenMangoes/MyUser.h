//
//  MyUser.h
//  RottenMangoes
//
//  Created by JIAN WANG on 6/8/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <Parse/Parse.h>

@interface MyUser : PFUser <PFSubclassing>

@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) NSMutableArray *favoriteMovies;

+ (MyUser *)currentUser;

@end
