//
//  ResultsViewController.h
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//


@import UIKit;
#import "ResultsContainerViewController.h"

@interface WebResultsViewController : UIViewController

@property (nonatomic, weak) id<SearchResultsDelegate> delegate;
@end
