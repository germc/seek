//
//  ViewController.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "SearchViewController.h"
#import "ResultsViewController.h"

// Models
#import "AutocompleteAPI.h"

// Views
#import "SuggestionCell.h"

// Categories
#import "NSArray+reversedArray.h"

// Other
#import "PanInteractiveTransitionController.h"
#import "PushBackTransition.h"


static NSUInteger const kNumberOfSuggestions = 6;
static NSString *const kSearchToResultsSegueID = @"SearchToResultsSegue";

@interface SearchViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) AutocompleteAPI *autocompleteAPI;
@property (nonatomic, strong) NSArray *suggestions;

@end

@implementation SearchViewController {
    NSInteger _touchedCellIndex;
    NSString *_searchQuery;
    PanInteractiveTransitionController *_interactiveTransitionController;
    PushBackTransition *_pushBackTransition;
    
}


#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _interactiveTransitionController = [PanInteractiveTransitionController new];
    _pushBackTransition = [PushBackTransition new];
    self.navigationController.delegate = self;
    
    self.suggestions = [NSMutableArray new];
    self.autocompleteAPI = [AutocompleteAPI new];
    [self.searchTextField becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.searchTextField becomeFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultsViewController *results = segue.destinationViewController;
    results.searchQuery = _searchQuery;
}

#pragma mark - Helpers
-(void)addSuggestions:(NSArray *)newSuggestions {
    
    // Limit the number of suggestions shown
    NSPredicate *resultsPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ( [newSuggestions indexOfObject:evaluatedObject] < kNumberOfSuggestions);
    }];
    self.suggestions = [[newSuggestions filteredArrayUsingPredicate:resultsPredicate] reversedArray];
    
    [self.collectionView reloadData];
}

#pragma mark - UITextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    
    [self.autocompleteAPI suggestionsForQuery:self.searchTextField.text withCompletionHandler:^(NSArray *results, NSError *error) {
        [self addSuggestions:results];
    }];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    _searchQuery = self.searchTextField.text;
    [self performSegueWithIdentifier:kSearchToResultsSegueID sender:self];
    
    return YES;
}

#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _searchQuery = self.suggestions[_touchedCellIndex];
    [self performSegueWithIdentifier:kSearchToResultsSegueID sender:self];
}

#pragma mark - UICollectionView Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.suggestions.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SuggestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SuggestionCell class]) forIndexPath:indexPath];

    NSString *suggestionText = self.suggestions[indexPath.item];
    cell.textLabel.text = suggestionText;
    
    return cell;
}

#pragma mark - UINavigationController Delegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        [_interactiveTransitionController attachToViewController:toVC];
    }
    return operation == UINavigationControllerOperationPop ? _pushBackTransition : nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return _interactiveTransitionController.interactionInProgress ? _interactiveTransitionController : nil;
}


@end
