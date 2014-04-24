//
//  RSNetworkController.h
//  GithubToGo
//
//  Created by Reed Sweeney on 4/22/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol RSNetworkControllerDelegate <NSObject>
//
//- (void)downloadedRepos:(NSMutableArray *)repoResults;
//
//@end

@interface RSNetworkController : NSObject

@property (nonatomic, strong) NSMutableArray *repoResults;
@property (nonatomic, strong) NSMutableArray *followingResults;
//@property (nonatomic, unsafe_unretained) id<RSNetworkControllerDelegate> delegate;

- (void)requestOAuthAccessWithCompletion:(void(^)())completeOAuthAccess;
- (BOOL)checkForOAuthToken;
- (void)handleOAuthCallbackWithURL:(NSURL *)url;
- (void)retrieveReposForCurrentUser:(void(^)(NSMutableArray *repos))completionBlock;
- (void)retrieveFollowingForCurrentUser:(void(^)(NSMutableArray *following))completionBlock;

@end
