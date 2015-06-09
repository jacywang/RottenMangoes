//
//  SignupViewController.m
//  RottenMangoes
//
//  Created by JIAN WANG on 6/8/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "SignupViewController.h"
#import "MyUser.h"

@interface SignupViewController () {
    NSArray *_userTypes;
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userTypes = @[@"Movie Critic", @"Casual Movie Fan"];
    self.userType = _userTypes[0];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
//    self.pickerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    self.userImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)imagePickerButtonPressed:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
        
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)signupButtonPressed:(UIButton *)sender {
    
    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username and password field cannot be empty!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }

    NSData *imageData = UIImagePNGRepresentation(self.userImageButton.imageView.image);
    PFFile *profileImageFile = [PFFile fileWithName:@"image.png" data:imageData];
    
    [profileImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Please save your info again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        } else {
            
            MyUser *user = [MyUser object];
            user.username = self.usernameTextField.text;
            user.password = self.passwordTextField.text;
            user.userType = self.userType;
            user.imageFile = profileImageFile;
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"You have signed up!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    NSLog(@"Error - %@",[error userInfo][@"error"]);
                }
            }];
        }
    }];
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.userImageButton.imageView.image = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDeledate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    switch(buttonIndex) {
        case 0:
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIPickerView DataSource and Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _userTypes.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _userTypes[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.userType = _userTypes[row];
}

@end
