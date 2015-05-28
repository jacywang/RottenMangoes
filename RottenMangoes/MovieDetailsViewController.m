//
//  MovieDetailsViewController.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.movie.title;
    self.titleAndYearLabel.text = [[[self.movie.title stringByAppendingString:@" ("] stringByAppendingString:[NSString stringWithFormat:@"%d", self.movie.year]] stringByAppendingString:@")"];
    self.mmpaRatingLabel.text = self.movie.mpaaRating;
    self.mmpaRatingLabel.clipsToBounds = YES;
    self.mmpaRatingLabel.layer.cornerRadius = 5.0f;
    self.runtimeLabel.text = [NSString stringWithFormat:@"%d mins", self.movie.runtime];
    self.releaseDateLabel.text = self.movie.releaseDateInTheatre;
    self.synopsisLabel.text = self.movie.synopsis;
    self.thumbnailImageView.image = self.movie.thumbnailImage;
    [self fetchReviews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)fetchReviews {
    NSURL *url = [NSURL URLWithString:self.movie.reviewsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.movie.reviewsArray = dict[@"reviews"];
                self.firstReviewLabel.text = [[@"\"" stringByAppendingString:self.movie.reviewsArray[0][@"quote"]] stringByAppendingString:@"\""];
                self.secondReviewLabel.text = [[@"\"" stringByAppendingString:self.movie.reviewsArray[1][@"quote"]] stringByAppendingString:@"\""];
                self.thirdReviewLabel.text = [[@"\"" stringByAppendingString:self.movie.reviewsArray[2][@"quote"]] stringByAppendingString:@"\""];
            });
        }
    }];
    [task resume];
}

@end
