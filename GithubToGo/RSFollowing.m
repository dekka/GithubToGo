//
//  RSFollowing.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/24/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSFollowing.h"

@interface RSFollowing()

@property (nonatomic, strong) NSURL *followingAvatarURL;

@end

@implementation RSFollowing

- (instancetype)initFollowingWithJson:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.name = [dictionary objectForKey:@"login"];
        self.html_url = [dictionary objectForKey:@"html_url"];
        self.followingAvatarPath = [dictionary objectForKey:@"avatar_url"];
    }
    return self;
}

- (void)downloadFollowingAvatarWithCompletionBlock:(void (^)())completion
{
    [self downloadFollowingAvatarOnQueue:[NSOperationQueue new] withCompletionBlock:completion];
}

- (void)downloadFollowingAvatarOnQueue:(NSOperationQueue *)queue withCompletionBlock:(void(^)())completion
{
    self.followingImageDownloadOp = [NSBlockOperation blockOperationWithBlock:^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:self.followingAvatarURL];
        _followingAvatarImage = [UIImage imageWithData:imageData];
        [[NSOperationQueue mainQueue] addOperationWithBlock:completion];
        
    }];
    [queue addOperation:self.followingImageDownloadOp];
}

- (void)cancelFollowingAvatarDownload
{
    if (!self.followingImageDownloadOp.isExecuting)
    {
        [self.followingImageDownloadOp cancel];
    }
}

- (NSURL *)followingAvatarURL
{
    return [NSURL URLWithString:_followingAvatarPath];
}


@end
