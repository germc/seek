//
//  ResultsContainerViewController.m
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "ResultsContainerViewController.h"

// Models
#import "SearchAPI.h"
#import "BingImageSearchResult.h"

static NSString * const kEmbedWebResults = @"EmbedWebResults";
static NSString * const kEmbedImageResults = @"EmbedImageResults";

@interface ResultsContainerViewController ()
@property (nonatomic, strong) NSString *currentSegueIdentifier;

// Models
@property (nonatomic, strong) NSArray *webSearchResults;
@property (nonatomic, strong) NSArray *imageSearchResults;
@property (nonatomic, strong) NSMutableDictionary *imageThumbnails;
@property (nonatomic, strong) SearchAPI *searchAPI;
@end

@implementation ResultsContainerViewController

#pragma mark - Accessors
-(SearchAPI *)searchAPI {
    
    if (!_searchAPI) {
        _searchAPI = [SearchAPI new];
    }
    return _searchAPI;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageThumbnails = [NSMutableDictionary new];
    NSLog(@"Results Container View Did Load");
    
// Web Results are shown first by default
    self.currentSegueIdentifier = kEmbedWebResults;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [segue.destinationViewController setValue:self forKey:@"delegate"];
    
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

#pragma mark - Transition Helpers
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

#pragma mark - Public API
-(void)webSearchResultsWithCompletionHandler:(CompletionHandler)completion {
    
    if (self.webSearchResults.count > 0) {
        completion(self.webSearchResults, nil);
    }
    else {
        [self.searchAPI searchWithQuery:self.searchQuery completion:^(NSArray *results, NSError *error) {
            self.webSearchResults = [results copy];
            completion(self.webSearchResults, error);
        }];
    }
}

-(void)imageSearchResultsWithCompletionHandler:(CompletionHandler)completion {
    
    if (self.imageSearchResults.count > 0) {
        completion(self.imageSearchResults, nil);
    }
    else {
        [self.searchAPI imageSearchWithQuery:self.searchQuery completion:^(NSArray *results, NSError *error) {
            self.imageSearchResults = [results copy];
            completion(self.imageSearchResults, error);
        }];
    }
}

-(void)imageThumbnailForSearchResult:(BingImageSearchResult *)searchResult withCompletionHandler:(ImageDownloadCompletionHandler)completion {
    
    if (self.imageThumbnails[searchResult.thumbnailURL]) {
        completion(self.imageThumbnails[searchResult.thumbnailURL]);
    }
    else {
        [self.searchAPI loadImageFromURL:searchResult.thumbnailURL withCompletion:^(UIImage *image) {
            self.imageThumbnails[searchResult.thumbnailURL] = [image copy];
            completion(self.imageThumbnails[searchResult.thumbnailURL]);
        }];
    }
}

@end


