//
//  MovieDetailsViewController.h
//  Rotten Tomatoes
//
//  Created by Sarp Centel on 2/5/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsis;

@property (strong, nonatomic) NSDictionary *movieData;

@end
