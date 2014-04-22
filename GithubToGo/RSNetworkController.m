//
//  RSNetworkController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/22/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSNetworkController.h"

@implementation RSNetworkController

#define GITHUB_CLIENT_ID @"8cb20d1d2f334883351e"
#define GITHUB_CLIENT_SECRET @"703a6a50019b604eed38c2f8eaac68b2eb4e2c54"
#define GITHUB_CALLBACK_URI @"gitauth://git_callback"
#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"

- (void)requestOAuthAccess
{
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)handleOAuthCallbackWithURL:(NSURL *)url
{
    NSLog(@" %@",url);
    NSString *code = [self getCodeFromCallbackURL:url];
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET,code];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error.description);
        }
        NSLog(@"response: %@",response.description);
        [self convertResponseDataIntoToken:data];
        
    }];
    [postDataTask resume];
}

- (NSString *)convertResponseDataIntoToken:(NSData *)responseData
{
    NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSArray *tokenComponents = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *accessTokenWithCode = tokenComponents[0];
    NSArray *access_token_array = [accessTokenWithCode componentsSeparatedByString:@"="];
    
    NSLog(@"%@",access_token_array[1]);
    
    return access_token_array[1];
}


- (NSString *)getCodeFromCallbackURL:(NSURL *)callbackURL
{
    NSString *query = [callbackURL query];
    NSLog(@" %@",query);
    NSArray *components = [query componentsSeparatedByString:@"code="];
    
    return [components lastObject];
}

@end
