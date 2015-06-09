//
//  ProfileViewController.m
//  RottenMangoes
//
//  Created by JIAN WANG on 6/8/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyUser *currentuser = [MyUser currentUser];
    self.usernameLabel.text = currentuser.username;
    self.userTypeLabel.text = currentuser.userType;
    self.profileImageView.file = currentuser.imageFile;
    [self.profileImageView loadInBackground];
    
}

@end
