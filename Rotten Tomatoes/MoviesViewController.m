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
#import "UIImageView+AFNetworking.h"
#import "MovieDetailsViewController.h"
@import Foundation;

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDictionary *parsedData;

@end

@implementation MoviesViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parsedData[@"movies"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentMovie = [self.parsedData[@"movies"] objectAtIndex:[indexPath row]];

    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    movieCell.movieName.text = [currentMovie objectForKey:@"title"];
    movieCell.movieDescription.text = [currentMovie objectForKey:@"synopsis"];
    [movieCell.movieImage setImageWithURL:[NSURL URLWithString:[currentMovie valueForKeyPath:@"posters.thumbnail"]]];

    return movieCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *controller = [[MovieDetailsViewController alloc] init];
    controller.movieData = self.parsedData[@"movies"][indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self loadDataFromNetwork];
}

- (void) loadDataFromNetwork {
    [self.errorView setHidden:YES];
    [SVProgressHUD show];

    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=30&country=us&apikey=ucc82c7tvbhcyxx65sac4gwz"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            [SVProgressHUD dismiss];
            [self.errorView setHidden:NO];
        } else {
            self.parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
    }];
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
