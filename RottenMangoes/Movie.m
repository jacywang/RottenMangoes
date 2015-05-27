//
//  Movie.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(instancetype)initWithTitle:(NSString *)title andYear:(NSString *)year andMpaaRating:(NSString *)rating andReleaseDate:(NSString *)date andSynopsis:(NSString *)synopsis andImageURL:(NSString *)imageURL{
    self = [super init];
    if (self) {
        _title = title;
        _year = year;
        _mpaaRating = rating;
        _releaseDateInTheatre = date;
        _synopsis = synopsis;
        [self fetchImage:imageURL];
    }
    return self;
}

- (void)fetchImage:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        self.thumbnail = [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
    }];
    [downloadPhotoTask resume];
}

@end
