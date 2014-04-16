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

// Transitions
#import "PanInteractiveTransitionController.h"
#import "PushBackTransition.h"


static NSUInteger const kNumberOfSuggestions = 8;
static NSString * const kSearchToResultsSegueID = @"SearchToResultsSegue";

@interface SearchViewController ()
<
UITextFieldDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UINavigationControllerDelegate
>
// Models
@property (nonatomic, strong) AutocompleteAPI *autocompleteAPI;
@property (nonatomic, strong) NSArray *suggestions;

// Views
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// Other
@property (nonatomic, strong) NSString *searchQuery;
@property (nonatomic, strong) PanInteractiveTransitionController *interactiveTransitionController;
@property (nonatomic, strong) PushBackTransition *pushBackTransition;
@end

@implementation SearchViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interactiveTransitionController = [PanInteractiveTransitionController new];
    self.pushBackTransition = [PushBackTransition new];
    self.navigationController.delegate = self;
    
    self.suggestions = [NSMutableArray new];
    self.autocompleteAPI = [AutocompleteAPI new];
    [self.searchTextField becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchTextField.alpha = 0.0;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchTextField becomeFirstResponder];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.searchTextField.alpha = 1.0;
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultsViewController *results = segue.destinationViewController;
    results.searchQuery = self.searchQuery;
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
    [self.autocompleteAPI suggestionsForQuery:self.searchTextField.text
                        withCompletionHandler:^(NSArray *results, NSError *error) {
                            [self addSuggestions:results];
                        }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.searchQuery = self.searchTextField.text;
    [self performSegueWithIdentifier:kSearchToResultsSegueID sender:self];
    
    return YES;
}

#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.searchQuery = self.suggestions[indexPath.row];
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
        [self.interactiveTransitionController attachToViewController:toVC];
    }
    return operation == UINavigationControllerOperationPop ? self.pushBackTransition : nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransitionController.interactionInProgress ? self.interactiveTransitionController : nil;
}


@end
