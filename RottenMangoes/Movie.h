//
//  Movie.h
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int year;
@property (nonatomic, strong) NSString *mpaaRating;
@property (nonatomic, assign) int runtime;
@property (nonatomic, strong) NSString *releaseDateInTheatre;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) NSString *reviewsURL;
@property (nonatomic, strong) NSArray *reviewsArray;


-(instancetype)initWithTitle:(NSString *)title andYear:(int)year andMpaaRating:(NSString *)rating andRunTime:(int)runtime andReleaseDate:(NSString *)date andSynopsis:(NSString *)synopsis andImageURL:(NSString *)imageURL andReviewsURL:(NSString *)reviewsURL;

@end