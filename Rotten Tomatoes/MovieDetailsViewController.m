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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.movieTitle.text = self.movieData[@"title"];
    self.movieSynopsis.text = self.movieData[@"synopsis"];
    [self.movieSynopsis sizeToFit];
    
    // API returns thumbnails for original URLS
    // Hack it by changing _tmb with _ori
    NSString *thumb = self.movieData[@"posters"][@"original"];
    NSString *original = [thumb stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
                       
    [self.movieImage setImageWithURL: [NSURL URLWithString:original]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
