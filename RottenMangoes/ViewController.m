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
#import "MovieDetailsViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self fetchData];
    self.collectionView.allowsMultipleSelection = NO;
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
                Movie *movie = [[Movie alloc] initWithTitle:item[@"title"] andYear:[item[@"year"] intValue] andMpaaRating:item[@"mpaa_rating"] andRunTime:[item[@"runtime"] intValue] andReleaseDate:item[@"release_dates"][@"theater"] andSynopsis:item[@"synopsis"]  andImageURL:item[@"posters"][@"thumbnail"] andReviewsURL:item[@"links"][@"reviews"] andAlternateURL:item[@"links"][@"alternate"]];
                [self.movies addObject:movie];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }];
    [task resume];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMovie"]) {
        MovieDetailsViewController *movieDetailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        movieDetailViewController.movie = self.movies[indexPath.row];
    }
}

#pragma mark - CollectionView datasource and delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.row];
    [cell fetchImage:movie];
    cell.titleLabel.text = movie.title;
    return cell;
}

@end
