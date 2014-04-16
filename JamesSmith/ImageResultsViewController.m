//
//  ImageResultsViewController.m
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "ImageResultsViewController.h"

// Other
#import "ArrayCollectionViewDataSource.h"

@interface ImageResultsViewController ()
@property (nonatomic, strong)ArrayCollectionViewDataSource *collectionViewDataSource;
@end

@implementation ImageResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( !(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) ) {
        return nil;
    }
    
    // Initial setup here

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

@end
