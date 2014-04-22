//
//  RSNetworkController.h
//  GithubToGo
//
//  Created by Reed Sweeney on 4/22/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSNetworkController : NSObject

-(void)requestOAuthAccess;
-(void)handleOAuthCallbackWithURL:(NSURL *)url;


@end
