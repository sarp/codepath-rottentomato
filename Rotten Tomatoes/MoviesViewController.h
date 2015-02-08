//
//  MoviesViewController.h
//  Rotten Tomatoes
//
//  Created by Sarp Centel on 2/3/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate>

- (id) initWithURL:(NSString*) apiURL accessToken:(NSString*) accessToken;

@end
