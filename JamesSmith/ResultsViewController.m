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

static NSString * const kShowImageResults = @"Show Image Results";
static NSString * const kShowWebResults = @"Show Web Results";

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resultsToggleButton;
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
    self.resultsToggleButton.title = ([self.resultsToggleButton.title isEqualToString:kShowImageResults]) ? kShowWebResults : kShowImageResults;
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
