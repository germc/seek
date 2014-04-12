//
//  ResultsViewController.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "ResultsViewController.h"
#import "WebViewController.h"

// Models
#import "SearchAPI.h"
#import "BingSearchResult.h"

// Views
#import "ResultCell.h"


static NSString *const kResultsToWebSegue = @"ResultsToWebSegue";

@interface ResultsViewController ()
@property (nonatomic, strong)SearchAPI *searchAPI;
@property (nonatomic, strong)NSMutableArray *searchResults;
@property (nonatomic, strong)UIActivityIndicatorView *spinner;
@end

@implementation ResultsViewController {
    NSInteger _touchedRowIndex;
}

#pragma mark - Lifecycle
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.searchAPI = [SearchAPI new];
        self.searchResults = [NSMutableArray new];
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.spinner.center = CGPointMake(self.tableView.center.x, 65);
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.tableView addSubview:self.spinner];
    
    [self fetchNewResults];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController *web = segue.destinationViewController;
    web.searchResult = self.searchResults[_touchedRowIndex];
}

#pragma mark - Helpers
-(void)fetchNewResults {
    
    [self.spinner startAnimating];
    [self.searchAPI searchWithQuery:self.searchQuery completion:^(NSArray *results, NSError *error) {
        [self.spinner stopAnimating];
        if (error) {
            NSLog(@"Error On Results VC: %@", error);
        }
        else {
            [self.searchResults addObjectsFromArray:results];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _touchedRowIndex = indexPath.row;
    [self performSegueWithIdentifier:kResultsToWebSegue sender:self];
}


#pragma mark - TableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResultCell class])];
    BingSearchResult *searchResult = self.searchResults[indexPath.row];
    
    cell.titleLabel.text = searchResult.title;
    cell.linkLabel.text = searchResult.url.description;
    cell.descriptionTextView.text = searchResult.descriptionText;
    
    return cell;
}


@end
