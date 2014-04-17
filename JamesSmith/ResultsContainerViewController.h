//
//  ResultsContainerViewController.h
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

typedef void(^CompletionHandler)(NSArray *results, NSError *error);
typedef void (^ImageDownloadCompletionHandler)(UIImage *image);

@class BingImageSearchResult;

@protocol SearchResultsDelegate <NSObject>
-(void)webSearchResultsWithCompletionHandler:(CompletionHandler)completion;
-(void)imageSearchResultsWithCompletionHandler:(CompletionHandler)completion;
-(void)imageThumbnailForSearchResult:(BingImageSearchResult *)searchResult withCompletionHandler:(ImageDownloadCompletionHandler)completion;
@end

@import UIKit;

@interface ResultsContainerViewController : UIViewController <SearchResultsDelegate>

// Weak because container has strong ref
@property (nonatomic, weak) NSString *searchQuery;

// Called when the bar button is pressed in the container
-(void)swapViewControllers;

// Called by children to access search results
-(void)webSearchResultsWithCompletionHandler:(CompletionHandler)completion;
-(void)imageSearchResultsWithCompletionHandler:(CompletionHandler)completion;
-(void)imageThumbnailForSearchResult:(BingImageSearchResult *)searchResult withCompletionHandler:(ImageDownloadCompletionHandler)completion;
@end
