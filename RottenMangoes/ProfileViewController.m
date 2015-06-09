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

#pragma mark - UITableViewDataSource and Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MyUser currentUser].favoriteMovies.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"favoriteMovieCell" forIndexPath:indexPath];
    cell.textLabel.text = [MyUser currentUser].favoriteMovies[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
