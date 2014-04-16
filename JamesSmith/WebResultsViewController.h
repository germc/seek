//
//  ResultsViewController.h
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

@import UIKit;

@interface WebResultsViewController : UIViewController

// Weak because container has strong ref
@property (nonatomic, weak) NSString *searchQuery;

@end
