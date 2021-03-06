//
//  ResultsViewController.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "ResultsContainerViewController.h"
#import "WebResultsViewController.h"
#import "WebViewController.h"

// Models
#import "BingSearchResult.h"

// Views
#import "BasicResultCell.h"

// Other
#import "ArrayTableViewDataSource.h"

static NSString * const kResultsToWebSegue = @"ResultsToWebSegue";

@interface WebResultsViewController () <UITableViewDelegate>
// Models
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableDictionary *offScreenCells;
@property (nonatomic, strong) ArrayTableViewDataSource *tableViewDataSource;

// Views
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *displayToggleButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

// Other
@property (nonatomic, assign) NSInteger touchedRowIndex;
@end

@implementation WebResultsViewController

#pragma mark - Lifecycle
-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if ( !(self = [super initWithCoder:aDecoder]) ) {
        return nil;
    }
    self.offScreenCells = [NSMutableDictionary dictionary];
    self.searchResults = [NSMutableArray new];
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
// TableView setup
    ConfigureCell configureCellBlock = ^void(UITableViewCell *cell, BingSearchResult *searchResult) {
        ((BasicResultCell *)cell).titleLabel.text = searchResult.title;
        ((BasicResultCell *)cell).linkLabel.text = searchResult.url.description;
        ((BasicResultCell *)cell).descriptionLabel.text = searchResult.descriptionText;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    };
    
    NSString *cellIdentifier = NSStringFromClass([BasicResultCell class]);
    [self.tableView registerClass:[BasicResultCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableViewDataSource = [[ArrayTableViewDataSource alloc] initWithItems:self.searchResults
                                                       cellIdentifier:cellIdentifier
                                                   configureCellBlock:configureCellBlock];
    self.tableView.dataSource = self.tableViewDataSource;
    
// Spinner setup
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.spinner.center = CGPointMake(self.tableView.center.x, 65);
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

    
    if (self.searchResults.count == 0) {
        [self fetchNewResults];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController *web = segue.destinationViewController;
    web.searchResult = self.searchResults[self.touchedRowIndex];
}

#pragma mark - IBActions
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)displayToggleButtonPressed:(id)sender {
    // Show photos
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.touchedRowIndex = indexPath.row;
    [self performSegueWithIdentifier:kResultsToWebSegue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = NSStringFromClass([BasicResultCell class]);
    
    BasicResultCell *cell = self.offScreenCells[reuseID];
    
    if (!cell) {
        cell = [BasicResultCell new];
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

#pragma mark - Helpers
-(void)fetchNewResults {
    [self.spinner startAnimating];
    [self.tableView addSubview:self.spinner];
    
    [self.delegate webSearchResultsWithCompletionHandler:^(NSArray *results, NSError *error) {
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
        
        if (error) {
            NSLog(@"Error:%@", error);
        }
        else {
            [self.searchResults addObjectsFromArray:results];
            [self.tableView reloadData];
        }
    }];
}


@end
