//
//  MovieCell.h
//  Rotten Tomatoes
//
//  Created by Sarp Centel on 2/3/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@end
