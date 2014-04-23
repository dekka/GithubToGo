//
//  RSNetworkController.h
//  GithubToGo
//
//  Created by Reed Sweeney on 4/22/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSNetworkControllerDelegate <NSObject>

- (void)downloadedRepos:(NSMutableArray *)repoResults;

@end

@interface RSNetworkController : NSObject

@property (nonatomic, strong) NSMutableArray *repoResults;
@property (nonatomic, unsafe_unretained) id<RSNetworkControllerDelegate> delegate;

- (void)requestOAuthAccess;
- (void)handleOAuthCallbackWithURL:(NSURL *)url;
- (void)retrieveReposForCurrentUser;

@end
