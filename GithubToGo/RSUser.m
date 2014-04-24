//
//  RSUser.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/24/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSUser.h"

@interface RSUser()

@property (nonatomic, strong) NSURL *avatarURL;

@end

@implementation RSUser

- (instancetype)initWithJson:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.name = [dictionary objectForKey:@"login"];
        self.html_url = [dictionary objectForKey:@"html_url"];
        self.avatarPath = [dictionary objectForKey:@"avatar_url"];
        
    }
    return self;
    
}

- (void)downloadAvatarWithCompletionBlock:(void (^)())completion
{
    [self downloadAvatarOnQueue:[NSOperationQueue new] withCompletionBlock:completion];
}

- (void)downloadAvatarOnQueue:(NSOperationQueue *)queue withCompletionBlock:(void(^)())completion
{
    self.imageDownloadOp = [NSBlockOperation blockOperationWithBlock:^{
        NSData *imageData = [NSData dataWithContentsOfURL:self.avatarURL];
        _avatarImage = [UIImage imageWithData:imageData];
        [[NSOperationQueue mainQueue] addOperationWithBlock:completion];

    }];
    [queue addOperation:self.imageDownloadOp];
}

- (void)cancelAvatarDownload
{
    if (!self.imageDownloadOp.isExecuting)
    {
        [self.imageDownloadOp cancel];
    }
}

- (NSURL *)avatarURL
{
    return [NSURL URLWithString:_avatarPath];
}
//for (NSDictionary *tempDict in tempArray) {
//    RSUser *user = [[RSUser alloc] init];
//    user.name = [tempDict objectForKey:@"login"];
//    user.html_url = [tempDict objectForKey:@"html_url"];
//    [self.searchResults addObject:user];
//
@end




