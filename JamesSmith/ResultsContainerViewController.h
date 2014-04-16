//
//  ResultsContainerViewController.h
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

typedef void(^CompletionHandler)(NSArray *results, NSError *error);

@protocol SearchResultsDelegate <NSObject>
-(void)webSearchResultsWithCompletionHandler:(CompletionHandler)completion;
-(void)imageSearchResultsWithCompletionHandler:(CompletionHandler)completion;
@end

@import UIKit;

@interface ResultsContainerViewController : UIViewController

// Weak because container has strong ref
@property (nonatomic, weak) NSString *searchQuery;

// Called when the bar button is pressed in the container
-(void)swapViewControllers;

// Called by children to access search results
-(void)webSearchResultsWithCompletionHandler:(CompletionHandler)completion;
-(void)imageSearchResultsWithCompletionHandler:(CompletionHandler)completion;

@end
