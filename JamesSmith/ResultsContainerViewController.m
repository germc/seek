//
//  ResultsContainerViewController.m
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "ResultsContainerViewController.h"

static NSString * const kEmbedWebResults = @"EmbedWebResults";
static NSString * const kEmbedImageResults = @"EmbedImageResults";

@interface ResultsContainerViewController ()
@property (nonatomic, strong) NSString *currentSegueIdentifier;
@end

@implementation ResultsContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
// Web Results are shown first by default
    self.currentSegueIdentifier = kEmbedWebResults;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
// Pass along the search query
    [segue.destinationViewController setValue:self.searchQuery forKey:@"searchQuery"];
    
    if ([segue.identifier isEqualToString:kEmbedWebResults]) {
        
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:self.childViewControllers.firstObject toViewController:segue.destinationViewController];
        }
        else {
            UIViewController *destinationVC = segue.destinationViewController;
            [self addChildViewController:destinationVC];
            destinationVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [self.view addSubview:destinationVC.view];
            [destinationVC didMoveToParentViewController:self];
        }
    }
    else if ([segue.identifier isEqualToString:kEmbedImageResults]) {
        [self swapFromViewController:self.childViewControllers.firstObject toViewController:segue.destinationViewController];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
}


- (void)swapViewControllers
{
    self.currentSegueIdentifier = (self.currentSegueIdentifier == kEmbedWebResults) ? kEmbedImageResults : kEmbedWebResults;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

@end


