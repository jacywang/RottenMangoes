//
//  CollectionViewCell.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(void)prepareForReuse {
    [self.downloadPhotoTask cancel];
}

- (void)fetchImage:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    self.downloadPhotoTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbnailImageView.image = image;
        });
        
    }];
    [self.downloadPhotoTask resume];
}

@end
