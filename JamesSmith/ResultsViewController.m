//
//  ResultsViewController.m
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultsContainerViewController.h"
@interface ResultsViewController ()
@property (nonatomic, weak)ResultsContainerViewController *resultsContainerViewController;
@end

@implementation ResultsViewController



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Embed Segue... Send search query along
    self.resultsContainerViewController = segue.destinationViewController;
    [segue.destinationViewController setValue:self.searchQuery forKey:@"searchQuery"];
}

#pragma mark - IBActions
- (IBAction)toggleDisplayedResults:(id)sender {
    [self.resultsContainerViewController swapViewControllers];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
