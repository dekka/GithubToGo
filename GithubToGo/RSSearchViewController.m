//
//  RSSearchViewController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/21/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSSearchViewController.h"
#import "RSWebViewController.h"
#import "RSRepo.h"

@interface RSSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation RSSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSMutableArray alloc] init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)reposForSearchString:(NSString *)searchString
{
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", searchString]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    
    NSMutableArray *tempArray = [jsonDict objectForKey:@"items"];
    
    for (NSDictionary *tempDict in tempArray) {
        RSRepo *repo = [[RSRepo alloc] init];
        repo.name = [tempDict objectForKey:@"name"];
        repo.html_url = [tempDict objectForKey:@"html_url"];
        [self.searchResults addObject:repo];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.searchResults[indexPath.row] name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self reposForSearchString:searchBar.text];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)burgerPressed:(id)sender
{
    [self.burgerDelegate handleBurgerPressed];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowGitPage"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSRepo *repo = [self.searchResults objectAtIndex:indexPath.row];
        RSWebViewController *wvc = (RSWebViewController *)segue.destinationViewController;
        wvc.searchResultURL = repo.html_url;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end








