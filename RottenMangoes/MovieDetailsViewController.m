//
//  MovieDetailsViewController.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MovieWebViewController.h"
#import "MapViewController.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"+Favorite"
                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(addFavorite)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.title = self.movie.title;
    self.moreButton.layer.cornerRadius = 10.0f;
    self.theaterButton.layer.cornerRadius = 10.0f;
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

-(void)addFavorite {
    MyUser *currentUser = [MyUser currentUser];
    
    if (currentUser.favoriteMovies.count == 0) {
        currentUser.favoriteMovies = [NSMutableArray array];
    }
    
    if ([currentUser.favoriteMovies containsObject:self.movie.title]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Duplicate" message:@"It's already in your favorite list!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        [currentUser.favoriteMovies addObject:self.movie.title];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"Added to favorite movie list!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                if ([[MyUser currentUser].userType isEqualToString:@"Movie Critic"]) {
                    NSDictionary *pushData = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSString stringWithFormat:@"%@ was favorited by a movie critic!", self.movie.title], @"alert",
                                              self.movie.title, @"movieTitle",
                                              @"Increment" ,@"badge",
                                              nil];
                    
                    PFPush *sendToCasualMovieFan = [[PFPush alloc] init];
                    [sendToCasualMovieFan setChannel:@"casualMovieFan"];
                    [sendToCasualMovieFan setData:pushData];
                    [sendToCasualMovieFan sendPushInBackground];
                }
                
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Add it again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
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
                if (self.movie.reviewsArray.count > 0) {
                    self.firstReviewLabel.text = [[@"\"" stringByAppendingString:self.movie.reviewsArray[0][@"quote"]] stringByAppendingString:@"\""];
                }
                if (self.movie.reviewsArray.count > 1) {
                    self.secondReviewLabel.text = [[@"\"" stringByAppendingString:self.movie.reviewsArray[1][@"quote"]] stringByAppendingString:@"\""];
                }
                if (self.movie.reviewsArray.count > 2) {
                    self.thirdReviewLabel.text = [[@"\"" stringByAppendingString:self.movie.reviewsArray[2][@"quote"]] stringByAppendingString:@"\""];
                }
            });
        }
    }];
    [task resume];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWeb"]) {
        MovieWebViewController *movieWebViewController = segue.destinationViewController;
        movieWebViewController.urlString = self.movie.alternateURL;
    } else if ([segue.identifier isEqualToString:@"showTheaterMap"]) {
        MapViewController *mapViewController = segue.destinationViewController;
        mapViewController.movie = self.movie;
    }
}

@end
