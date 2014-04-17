//
//  ImageResultsViewController.m
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Views
#import "ImageResultCell.h"

// Controllers
#import "ImageResultsViewController.h"

// Models
#import "ArrayCollectionViewDataSource.h"

// Other
#import "ArrayCollectionViewDataSource.h"

@interface ImageResultsViewController () <UICollectionViewDelegate>

// Views
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ArrayCollectionViewDataSource *collectionViewDataSource;
@property (nonatomic, strong) NSArray *searchResults;
@end

@implementation ImageResultsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *cellIdentifier = NSStringFromClass([ImageResultCell class]);
    [self.collectionView registerClass:[ImageResultCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionViewDataSource = [[ArrayCollectionViewDataSource alloc] initWithItems:self.searchResults cellIdentifier:cellIdentifier configureCellBlock:[self configureCell]];
    self.collectionView.dataSource = self.collectionViewDataSource;
}

#pragma mark - Collection View Delegate

#pragma mark - Helpers
-(ConfigureCell)configureCell {
    return ^void(UICollectionViewCell *cell, id item) {
        // Configure the cell
    };
}

-(void)fetchNewResults {
    //[self.spinner startAnimating];
    //[self.tableView addSubview:self.spinner];
    
    [self.delegate imageSearchResultsWithCompletionHandler:^(NSArray *results, NSError *error) {
        //[self.spinner stopAnimating];
        //[self.spinner removeFromSuperview];
        if (error) {
            NSLog(@"Error: %@", error);
        }
        else {
            self.searchResults = results;
            [self.collectionView reloadData];
        }
    }];
}
@end
