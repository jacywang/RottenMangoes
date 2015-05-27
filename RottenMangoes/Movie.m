//
//  Movie.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(instancetype)initWithTitle:(NSString *)title andYear:(NSString *)year andMpaaRating:(NSString *)rating andReleaseDate:(NSString *)date andSynopsis:(NSString *)synopsis andThumbnailImageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        _title = title;
        _year = year;
        _mpaaRating = rating;
        _releaseDateInTheatre = date;
        _synopsis = synopsis;
        _thumbnail = [UIImage imageNamed:imageName];
    }
    return self;
}

@end
