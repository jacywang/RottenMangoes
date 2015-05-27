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
    self.runtimeLabel.text = [NSString stringWithFormat:@"%d mins", self.movie.runtime];
    self.releaseDateLabel.text = self.movie.releaseDateInTheatre;
    self.synopsisLabel.text = self.movie.synopsis;
    self.thumbnailImageView.image = self.movie.thumbnailImage;
}


@end
