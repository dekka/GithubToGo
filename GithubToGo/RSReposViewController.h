//
//  RSReposViewController.h
//  GithubToGo
//
//  Created by Reed Sweeney on 4/21/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSBurgerProtocol.h"

@interface RSReposViewController : UIViewController

@property (nonatomic, unsafe_unretained)  id <RSBurgerProtocol> burgerDelegate;

@end
