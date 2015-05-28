//
//  MovieDetailsViewController.h
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleAndYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *mmpaRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdReviewLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic, strong) Movie *movie;

@end
