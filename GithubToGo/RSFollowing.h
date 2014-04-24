//
//  RSFollowing.h
//  GithubToGo
//
//  Created by Reed Sweeney on 4/24/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSRepo.h"

@interface RSFollowing : RSRepo

@property (nonatomic, strong) NSString *followingAvatarPath;
@property (nonatomic, strong) UIImage *followingAvatarImage;
@property (nonatomic, strong) NSBlockOperation *followingImageDownloadOp;

- (instancetype)initFollowingWithJson:(NSDictionary *)dictionary;
- (void)downloadFollowingAvatarWithCompletionBlock:(void(^)())completion;
- (void)downloadFollowingAvatarOnQueue:(NSOperationQueue *)queue withCompletionBlock:(void(^)())completion;
- (void)cancelFollowingAvatarDownload;

@end
