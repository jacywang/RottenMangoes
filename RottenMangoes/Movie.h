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
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *mpaaRating;
@property (nonatomic, strong) NSString *releaseDateInTheatre;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) UIImage *thumbnail;

-(instancetype)initWithTitle:(NSString *)title andYear:(NSString *)year andMpaaRating:(NSString *)rating andReleaseDate:(NSString *)date andSynopsis:(NSString *)synopsis andImageURL:(NSString *)imageURL;

@end