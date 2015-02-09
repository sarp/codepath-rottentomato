//
//  UIImageView+FadeIn.h
//  Rotten Tomatoes
//
//  Created by Sarp Centel on 2/8/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FadeIn)

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end
