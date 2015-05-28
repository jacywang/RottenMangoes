//
//  Movie.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(instancetype)initWithTitle:(NSString *)title andYear:(int)year andMpaaRating:(NSString *)rating andRunTime:(int)runtime andReleaseDate:(NSString *)date andSynopsis:(NSString *)synopsis andImageURL:(NSString *)imageURL andReviewsURL:(NSString *)reviewsURL{
    self = [super init];
    if (self) {
        _title = title;
        _year = year;
        _mpaaRating = rating;
        _runtime = runtime;
        _releaseDateInTheatre = date;
        _synopsis = synopsis;
        _thumbnailURL = imageURL;
        _reviewsURL = [reviewsURL stringByAppendingString:@"?apikey=sr9tdu3checdyayjz85mff8j&page_limit=3"];
        _reviewsArray = [NSArray array];
    }
    return self;
}

@end
