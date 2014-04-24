//
//  RSNetworkController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/22/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSNetworkController.h"
#import "RSRepo.h"
#import "RSUser.h"
#import "RSFollowing.h"

@interface RSNetworkController ()

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, copy) void (^completeOAuthAccess)();

@end

@implementation RSNetworkController




#define GITHUB_CLIENT_ID @"8cb20d1d2f334883351e"
#define GITHUB_CLIENT_SECRET @"703a6a50019b604eed38c2f8eaac68b2eb4e2c54"
#define GITHUB_CALLBACK_URI @"gitauth://git_callback"
#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"
#define GITHUB_API_URL @"https://api.github.com/"


- (id)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:configuration];
        
        self.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthToken"];
//        if (!self.token) {
//            [self requestOAuthAccess];
//        }
    }
    return self;
    
}

- (void)requestOAuthAccessWithCompletion:(void(^)())completeOAuthAccess
{
    self.completeOAuthAccess = completeOAuthAccess;
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (BOOL)checkForOAuthToken
{
    if (self.token) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)handleOAuthCallbackWithURL:(NSURL *)url
{
//    NSLog(@" %@",url);
    NSString *code = [self getCodeFromCallbackURL:url];
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET,code];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
//            NSLog(@"error: %@",error.description);
        }
//        NSLog(@"response: %@",response.description);
       self.token = [self convertResponseDataIntoToken:data];
        [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:@"OAuthToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.completeOAuthAccess();
        }];        
    }];
    [postDataTask resume];
}

- (NSString *)convertResponseDataIntoToken:(NSData *)responseData
{
    NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSArray *tokenComponents = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *accessTokenWithCode = tokenComponents[0];
    NSArray *access_token_array = [accessTokenWithCode componentsSeparatedByString:@"="];
    
//    NSLog(@"%@",access_token_array[1]);
    
    return access_token_array[1];
}


- (NSString *)getCodeFromCallbackURL:(NSURL *)callbackURL
{
    NSString *query = [callbackURL query];
//    NSLog(@" %@",query);
    NSArray *components = [query componentsSeparatedByString:@"code="];
    
    return [components lastObject];
}


- (void)retrieveReposForCurrentUser:(void(^)(NSMutableArray *repos))completionBlock
{
    NSURL *userRepoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/repos",GITHUB_API_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:userRepoURL];
    [request setHTTPMethod:@"GET"];
//    NSLog(@" %@",self.token);
    [request setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *repoDataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"response: %@",response.description);
   
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.repoResults = [NSMutableArray new];
        
//        for (NSDictionary *tempDict in jsonArray) {
//            RSRepo *repo = [[RSRepo alloc] init];
//            repo.name = [tempDict objectForKey:@"name"];
//            repo.html_url = [tempDict objectForKey:@"html_url"];
//            [self.repoResults addObject:repo];
//        }
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RSRepo *repo = [RSRepo new];
            repo.name = [obj objectForKey:@"name"];
            repo.html_url = [obj objectForKey:@"html_url"];
            [self.repoResults addObject:repo];
        }];
        
        completionBlock(self.repoResults);
    }];
    [repoDataTask resume];    
}

- (void)retrieveFollowingForCurrentUser:(void (^)(NSMutableArray *))completionBlock
{
    NSURL *followingURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/following",GITHUB_API_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:followingURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"token %@",self.token] forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *followingDataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.followingResults = [NSMutableArray new];
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RSFollowing *following = [RSFollowing new];
            following.name = [obj objectForKey:@"login"];
            following.html_url = [obj objectForKey:@"html_url"];
            following.followingAvatarPath = [obj objectForKey:@"avatar_url"];
            [self.followingResults addObject:following];
        }];
        completionBlock(self.followingResults);
    }];
    [followingDataTask resume];
}



@end













