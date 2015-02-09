//
//  MovieDetailsViewController.m
//  Rotten Tomatoes
//
//  Created by Sarp Centel on 2/5/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.movieTitle.text = [NSString stringWithFormat:@"%@ (%@)", self.movieData[@"title"], self.movieData[@"year"]];
    self.movieSynopsis.text = self.movieData[@"synopsis"];
    
    NSString *audienceScore = self.movieData[@"ratings"][@"audience_score"];
    NSString *criticsScore = self.movieData[@"ratings"][@"critics_score"];
    self.movieScores.text = [NSString stringWithFormat:@"Audience Score: %@ Critics Score: %@", audienceScore, criticsScore];
    
    // API returns thumbnails for original URLS
    // Hack it by changing _tmb with _ori
    NSString *thumb = self.movieData[@"posters"][@"original"];
    NSString *original = [thumb stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
    
    [self.loadingIndicator setHidden:NO];
    [self.loadingIndicator startAnimating];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:original]];
    [self.movieImage setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.movieImage.image = image;
        [self.loadingIndicator stopAnimating];
        [self.loadingIndicator setHidden:YES];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self.loadingIndicator stopAnimating];
        [self.loadingIndicator setHidden:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
