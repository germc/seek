//
//  ImageResultsViewController.h
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageResultsViewController : UIViewController

// Weak because container has strong ref
@property (nonatomic, weak)NSString *searchQuery;
@end
