//
//  ResultsViewController.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "WebResultsViewController.h"
#import "WebViewController.h"

// Models
#import "SearchAPI.h"
#import "BingSearchResult.h"

// Views
#import "ResultCell.h"


static NSString *const kResultsToWebSegue = @"ResultsToWebSegue";

@interface WebResultsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)SearchAPI *searchAPI;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *searchResults;
@property (nonatomic, strong)UIActivityIndicatorView *spinner;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *displayToggleButton;
@property (nonatomic, strong)NSMutableDictionary *offScreenCells;
@end

@implementation WebResultsViewController {
    NSInteger _touchedRowIndex;
}

#pragma mark - Lifecycle
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.offScreenCells = [NSMutableDictionary dictionary];
        self.searchAPI = [SearchAPI new];
        self.searchResults = [NSMutableArray new];
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[ResultCell class] forCellReuseIdentifier:NSStringFromClass([ResultCell class])];
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.spinner.center = CGPointMake(self.tableView.center.x, 65);
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    if (self.searchResults.count == 0) {
        [self fetchNewResults];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController *web = segue.destinationViewController;
    web.searchResult = self.searchResults[_touchedRowIndex];
}

#pragma mark - IBActions
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)displayToggleButtonPressed:(id)sender {
    // Show photos
}

#pragma mark - Helpers
-(void)fetchNewResults {
    [self.spinner startAnimating];
    [self.tableView addSubview:self.spinner];
    [self.searchAPI searchWithQuery:self.searchQuery completion:^(NSArray *results, NSError *error) {
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    cell.descriptionLabel.text = searchResult.descriptionText;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = NSStringFromClass([ResultCell class]);
    
    ResultCell *cell = self.offScreenCells[reuseID];
    
    if (!cell) {
        cell = [ResultCell new];
        self.offScreenCells[reuseID] = cell;
    }
    
    BingSearchResult *searchResult = self.searchResults[indexPath.row];
    cell.titleLabel.text = searchResult.title;
    cell.descriptionLabel.text = searchResult.descriptionText;
    cell.linkLabel.text = searchResult.url.description;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Padding for separators
    height += 1;
    
    return height;
}

@end
