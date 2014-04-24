//
//  RSFollowingViewController.h
//  GithubToGo
//
//  Created by Reed Sweeney on 4/22/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSBurgerProtocol.h"

@interface RSFollowingViewController : UIViewController

@property (nonatomic, unsafe_unretained)  id <RSBurgerProtocol> burgerDelegate;


@end
