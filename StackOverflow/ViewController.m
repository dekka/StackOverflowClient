//
//  ViewController.m
//  StackOverflow
//
//  Created by Reed Sweeney on 5/16/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "ViewController.h"
#import "SOQuestion.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchResults = [[NSMutableArray alloc] init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.searchResults[indexPath.row] title];
    
    return cell;
}

- (void)stackOverflowSearch:(NSString *)searchString
{
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow", searchString]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
    
    NSMutableArray *tempArray = [jsonDict objectForKey:@"items"];
    
    for (NSDictionary *tempDict in tempArray) {
        SOQuestion *question = [[SOQuestion alloc] init];
        question.title = [tempDict objectForKey:@"title"];
        question.link = [tempDict objectForKey:@"link"];
        [self.searchResults addObject:question];
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.searchResults removeAllObjects];
    [self stackOverflowSearch:searchBar.text];
}


@end










