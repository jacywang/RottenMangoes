//
//  CollectionViewCell.h
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadPhotoTask;

- (void)fetchImage:(NSString *)urlString;

@end
