//
//  ImageResultsViewController.m
//  JamesSmith
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Views
#import "ImageResultCell.h"

// Controllers
#import "ImageResultsViewController.h"
#import "JTSImageViewController.h"

// Models
#import "BingImageSearchResult.h"
#import "ArrayCollectionViewDataSource.h"

// Other
#import "ArrayCollectionViewDataSource.h"
#import "OvershareKit.h"

@interface ImageResultsViewController ()
<
UICollectionViewDelegate,
JTSImageViewControllerInteractionsDelegate
>

// Views
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ArrayCollectionViewDataSource *collectionViewDataSource;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation ImageResultsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [NSMutableArray new];
    ConfigureCell configureCellBlock = ^void(ImageResultCell *cell, BingImageSearchResult *searchResult) {
        cell.imageView.image = nil;
        [self.delegate imageThumbnailForSearchResult:searchResult withCompletionHandler:^(UIImage *image) {
            cell.imageView.image = image;
        }];
    };
    
    NSString *cellIdentifier = NSStringFromClass([ImageResultCell class]);
    [self.collectionView registerClass:[ImageResultCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionViewDataSource = [[ArrayCollectionViewDataSource alloc] initWithItems:self.searchResults cellIdentifier:cellIdentifier configureCellBlock:configureCellBlock];
    self.collectionView.dataSource = self.collectionViewDataSource;
    
    [self fetchNewResults];
}

#pragma mark - Collection View Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    BingImageSearchResult *result = self.searchResults[indexPath.item];
    
    JTSImageInfo *imageInfo = [JTSImageInfo new];
    imageInfo.imageURL = result.fullSizeURL;
    imageInfo.referenceRect = [[collectionView layoutAttributesForItemAtIndexPath:indexPath] frame];
    imageInfo.referenceView = self.collectionView;
    imageInfo.altText = result.altText;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    imageViewer.interactionsDelegate = self;
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
}

#pragma mark - Helpers
-(void)fetchNewResults {
    //[self.spinner startAnimating];
    //[self.tableView addSubview:self.spinner];
    
    [self.delegate imageSearchResultsWithCompletionHandler:^(NSArray *results, NSError *error) {
        //[self.spinner stopAnimating];
        //[self.spinner removeFromSuperview];
        if (error) {
            NSLog(@"Error: %@", error);
        }
        else {
            [self.searchResults addObjectsFromArray:results];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - JTSImageViewer Delegate
-(void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer {
    [imageViewer dismiss:YES];
    OSKShareableContent *content = [OSKShareableContent
                                    contentFromImages:@[imageViewer.image]
                                    caption:[@"Share Image: " stringByAppendingString: imageViewer.imageInfo.altText]];
    [[OSKPresentationManager sharedInstance] presentActivitySheetForContent:content presentingViewController:self options:nil];
}

@end
