//
//  UIImageView+FadeIn.m
//  Rotten Tomatoes
//
//  Created by Sarp Centel on 2/8/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "UIImageView+FadeIn.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (FadeIn)

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
                       placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
                       fadeDuration:(NSTimeInterval)duration
{
    
    void (^myblock)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) = ^void((NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)) {
        
        // Execute original success block if there is one
        if (success != nil) {
            success(request, response, image);
        }

        self.image = image;
        
        // Only animate for network loads, do not animate from cache
        if (request) {
            [UIView animateWithDuration:duration animations:^{
                self.alpha = 1.0;
            }];
        } else {
            self.alpha = 1.0;
        }
    };
    
    [self setImageWithURLRequest:urlRequest placeholderImage:placeholderImage success:myblock failure:failure];
}

@end