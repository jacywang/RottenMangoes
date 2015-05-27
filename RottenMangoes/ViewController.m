//
//  ViewController.m
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "CollectionViewCell.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self fetchData];
}

- (void)fetchData {
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=50"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [[NSURLSession  sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            self.dataDownloaded = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = [[NSMutableArray alloc] init];
            for (NSDictionary *item in self.dataDownloaded[@"movies"]) {
                Movie *movie = [[Movie alloc] initWithTitle:item[@"title"] andYear:item[@"year"] andMpaaRating:item[@"mpaa_rating"] andReleaseDate:item[@"release_date"][@"theater"] andSynopsis:item[@"synopsis"] andThumbnailImageName:item[@"posters"][@"thumbnail"]];
                [self.movies addObject:movie];
            }
            [self.collectionView reloadData];
        }
    }];
    [task resume];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.row];
    cell.thumbnailImageView.image = movie.thumbnail;
    cell.titleLabel.text = movie.title;
    return cell;
}

@end
