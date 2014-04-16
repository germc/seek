//
//  AutocompleteAPI.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "AutocompleteAPI.h"

static NSString * const kGoogleAutoCompleteAPI = @"http://suggestqueries.google.com/complete/search";
static NSString * const kClientString = @"firefox";

@interface AutocompleteAPI () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@end

@implementation AutocompleteAPI

#pragma mark - Lifecycle
-(instancetype)init {
    
    if ( !(self = [super init]) ) {
        return nil;
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    return self;
}

#pragma mark - Public API
-(void)suggestionsForQuery:(NSString *)query withCompletionHandler:(QueryCompletionHandler)completion{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client=%@&q=%@",
                           kGoogleAutoCompleteAPI, kClientString, escapeString(query)];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *suggestionsTask = [self.session
                                             dataTaskWithURL:url
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                 
                                                 NSError *jsonError;
                                                 NSArray *suggestions = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError] lastObject];
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(suggestions, (error == nil) ? jsonError : error);
                                                 });
                                             }];
    [suggestionsTask resume];
}

@end
