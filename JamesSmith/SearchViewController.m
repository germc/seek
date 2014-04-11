//
//  ViewController.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "SearchViewController.h"
#import "AutocompleteAPI.h"

static NSUInteger const kNumberOfSuggestions = 14;

@interface SearchViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) AutocompleteAPI *autocompleteAPI;
@property (nonatomic, strong) NSArray *suggestions;

@end

@implementation SearchViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.autocompleteAPI = [AutocompleteAPI new];
        self.suggestions = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchTextField becomeFirstResponder];
    
}

#pragma mark - Helpers
-(void)addSuggestions:(NSArray *)newSuggestions {
    
    // Limit the number of suggestions shown
    NSPredicate *resultsPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ( [newSuggestions indexOfObject:evaluatedObject] < kNumberOfSuggestions);
    }];
    self.suggestions = [newSuggestions filteredArrayUsingPredicate:resultsPredicate];
    
    [self.collectionView reloadData];
}

#pragma mark - UITextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self.autocompleteAPI suggestionsForQuery:self.searchTextField.text withCompletionHandler:^(NSArray *results, NSError *error) {
        [self addSuggestions:results];
    }];
    
    return YES;
}

#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Load the webview with this suggestion
}

#pragma mark - UICollectionView Data Source
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
