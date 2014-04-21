//
//  RSRepo.h
//  GithubToGo
//
//  Created by Reed Sweeney on 4/21/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSRepo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *html_url;
@property (nonatomic, strong) NSData *html_cache;

@end
