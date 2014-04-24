//
//  RSUser.h
//  GithubToGo
//
//  Created by Reed Sweeney on 4/24/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSRepo.h"

@interface RSUser : RSRepo

@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSBlockOperation *imageDownloadOp;

- (instancetype)initWithJson:(NSDictionary *)dictionary;
- (void)downloadAvatarWithCompletionBlock:(void(^)())completion;
- (void)downloadAvatarOnQueue:(NSOperationQueue *)queue withCompletionBlock:(void(^)())completion;
- (void)cancelAvatarDownload;

@end
