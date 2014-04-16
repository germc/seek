//
//  ResultsViewController.m
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "ResultsViewController.h"
#import "ResultsContainerViewController.h"

@interface ResultsViewController ()
@property (nonatomic, weak) ResultsContainerViewController *resultsContainerViewController;
@end

@implementation ResultsViewController

#pragma mark - Lifecycle
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Embed Segue... Send search query along
    self.resultsContainerViewController = segue.destinationViewController;
    self.resultsContainerViewController.searchQuery = self.searchQuery;
}

#pragma mark - IBActions
- (IBAction)toggleDisplayedResults:(id)sender {
    [self.resultsContainerViewController swapViewControllers];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
