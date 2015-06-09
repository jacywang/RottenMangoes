//
//  ProfileViewController.h
//  RottenMangoes
//
//  Created by JIAN WANG on 6/8/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUser.h"
#import <ParseUI/ParseUI.h>

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
