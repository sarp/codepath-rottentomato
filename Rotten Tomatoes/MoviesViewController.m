//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by Sarp Centel on 2/3/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "SVProgressHUD.h"
#import "UIImageView+FadeIn.h"
#import "MovieDetailsViewController.h"
@import Foundation;

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDictionary *parsedData;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *boxOfficeTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *dvdTabBarItem;

@property (strong, nonatomic) NSString *apiUrl;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;

@end

@implementation MoviesViewController

- (id) initWithURL:(NSString*) apiURL accessToken:(NSString*) accessToken {
    if ((self = [super initWithNibName:@"MoviesViewController" bundle:nil])) {
        self.apiUrl = [NSString stringWithFormat:@"%@?limit=30&country=us&apikey=%@", apiURL, accessToken];
        self.searchResults = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentMovie = self.searchResults[indexPath.row];

    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    [movieCell.movieImage stopAnimating];
    movieCell.movieImage.alpha = 0;
    movieCell.movieName.text = [currentMovie objectForKey:@"title"];
    movieCell.movieDescription.text = [currentMovie objectForKey:@"synopsis"];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[currentMovie valueForKeyPath:@"posters.thumbnail"]]];
    [movieCell.movieImage setImageWithURLRequest:imageRequest success:nil failure:nil];

    return movieCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect current row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Dismiss search bar
    [self.movieSearchBar resignFirstResponder];
    // Navigate to movie
    MovieDetailsViewController *controller = [[MovieDetailsViewController alloc] init];
    controller.movieData = self.searchResults[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self loadDataFromNetwork];
}

- (void) loadDataFromNetwork {
    [self.errorView setHidden:YES];
    [SVProgressHUD show];
    [self.movieSearchBar resignFirstResponder];
    
    NSURL *url = [NSURL URLWithString:self.apiUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            [SVProgressHUD dismiss];
            [self.errorView setHidden:NO];
        } else {
            self.parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movieSearchBar.text = @"";
            [self.searchResults removeAllObjects];
            [self.searchResults addObjectsFromArray:self.parsedData[@"movies"]];
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchResults removeAllObjects];
    if (searchText.length == 0) {
        [self.searchResults addObjectsFromArray:self.parsedData[@"movies"]];
    } else {
        for (NSDictionary *movie in self.parsedData[@"movies"]) {
            NSRange range = [movie[@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [self.searchResults addObject:movie];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.movieSearchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *cell = [UINib nibWithNibName:@"MovieCell" bundle:nil];
    [self.tableView registerNib:cell forCellReuseIdentifier:@"MovieCell"];
    self.tableView.rowHeight = 100;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    [self loadDataFromNetwork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
