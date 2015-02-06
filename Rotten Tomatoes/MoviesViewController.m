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

@end

NSDictionary *parsedData;
UIRefreshControl *refreshControl;

@implementation MoviesViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [parsedData[@"movies"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (movieCell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"MovieCell" owner:self options:nil];
        movieCell = [nibs objectAtIndex:0];
    }
    
    NSDictionary *currentMovie = [parsedData[@"movies"] objectAtIndex:[indexPath row]];
    movieCell.movieName.text = [currentMovie objectForKey:@"title"];
    movieCell.movieDescription.text = [currentMovie objectForKey:@"synopsis"];
    NSLog(@"%@", [currentMovie valueForKeyPath:@"posters.thumbnail"]);
    [movieCell.movieImage setImageWithURL:[NSURL URLWithString:[currentMovie valueForKeyPath:@"posters.thumbnail"]]];

    return movieCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked on %ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *controller = [[MovieDetailsViewController alloc] init];
    controller.movieData = parsedData[@"movies"][indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"Refresh called");
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
            NSLog(@"There was en error");
            [SVProgressHUD dismiss];
            [self.errorView setHidden:NO];
        } else {
            //NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", [parsedData allKeys]);
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
    
    [self loadDataFromNetwork];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
