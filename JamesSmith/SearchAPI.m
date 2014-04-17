//
//  SearchAPI.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

// Controllers
#import "SearchAPI.h"

// Models
#import "BingSearchResult.h"
#import "BingImageSearchResult.h"

//Categories
#import "NSData+Base64.h"

static NSString * const kBingWebAPIURL = @"https://api.datamarket.azure.com/Bing/Search/";
static NSString * const kBingImageAPIURL = @"https://api.datamarket.azure.com/Bing/Search/";
static NSString * const kBingAccountKey = @"akhwO6KR36BNXHQfN3mkvm54ZilO06GhnjiyXiGb1L8";
static NSString * const kBingMarketString = @"en-us";

@interface SearchAPI () <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation SearchAPI

NSString * searchURLWithQuery(NSString *query);
NSString * buildAuthorizationHeader();

#pragma mark - Lifecycle
-(instancetype)init {
    
    if ( !(self = [super init]) ) {
        return nil;
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{
                                       @"Authorization" : buildAuthorizationHeader()
                                       }];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    return self;
}

#pragma mark - Public API
-(void)searchWithQuery:(NSString *)query completion:(SearchCompletionHandler)completion{
    NSString *urlString = searchURLWithQuery(query);
    NSURLSessionDataTask *searchTask = [self.session dataTaskWithURL:[NSURL URLWithString:urlString]
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                                                       if (error) {
                                                           completion(nil, error);
                                                       }
                                                       else {
                                                           NSError *jsonError;
                                                           NSDictionary *jsonDictionaryResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&jsonError];
                                                           NSArray *resultsArray = jsonDictionaryResults[@"d"][@"results"];
                                                           
                                                           NSMutableArray *bingResults = [NSMutableArray new];
                                                           [resultsArray enumerateObjectsUsingBlock:^(NSDictionary *result, NSUInteger idx, BOOL *stop) {
                                                               BingSearchResult *bingSearchResult = [BingSearchResult resultWithDictionary:result];
                                                               [bingResults addObject:bingSearchResult];
                                                           }];
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               completion([bingResults copy], jsonError);
                                                           });
                                                       }
                                                   }];
    [searchTask resume];
}

-(void)imageSearchWithQuery:(NSString *)query completion:(SearchCompletionHandler)completion {
    NSString *urlString = imageSearchURLWithQuery(query);
    NSURLSessionDataTask *searchTask = [self.session dataTaskWithURL:[NSURL URLWithString:urlString]
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                                                       if (error) {
                                                           completion(nil, error);
                                                       }
                                                       else {
                                                           NSError *jsonError;
                                                           NSDictionary *jsonDictionaryResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&jsonError];
                                                           NSArray *resultsArray = jsonDictionaryResults[@"d"][@"results"];
                                                           
                                                           NSMutableArray *bingResults = [NSMutableArray new];
                                                           [resultsArray enumerateObjectsUsingBlock:^(NSDictionary *result, NSUInteger idx, BOOL *stop) {
                                                               BingImageSearchResult *bingImageSearchResult = [BingImageSearchResult searchResultWithDictionary:result];
                                                               [bingResults addObject:bingImageSearchResult];
                                                           }];
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               completion([bingResults copy], jsonError);
                                                           });
                                                       }
                                                   }];
    
    [searchTask resume];
}

#pragma mark Private Methods
NSString * searchURLWithQuery(NSString *query) {
    NSString *format = @"JSON";
    NSInteger top = 10;
    
    NSMutableString *urlString = [NSMutableString new];
    [urlString appendString:kBingWebAPIURL];
    [urlString appendFormat:@"Web?$format=%@", format];
    [urlString appendFormat:@"&Query='%@'", escapeString(query)];
    [urlString appendFormat:@"&Market='%@'", escapeString(kBingMarketString)];
    [urlString appendFormat:@"&$top=%d", top];
    
    return [urlString copy];
}

NSString * imageSearchURLWithQuery(NSString *query) {
    NSString *format = @"JSON";
    NSInteger top = 20;
    
    NSMutableString *urlString = [NSMutableString new];
    [urlString appendString:kBingImageAPIURL];
    [urlString appendFormat:@"Image?$format=%@", format];
    [urlString appendFormat:@"&Query='%@'", escapeString(query)];
    [urlString appendFormat:@"&Market='%@'", escapeString(kBingMarketString)];
    [urlString appendFormat:@"&$top=%d", top];
    
    return urlString;
}

NSString * buildAuthorizationHeader() {
    NSString *authString = [NSString stringWithFormat:@"%@:%@", kBingAccountKey, kBingAccountKey];
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    NSLog(@"%@", authHeader);
    return authHeader;
}


@end
