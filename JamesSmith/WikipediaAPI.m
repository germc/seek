//
//  WikipediaAPI.m
//  Seek
//
//  Created by Jamie Smith on 4/25/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "WikipediaAPI.h"

static NSString * const kWikipediaAPI = @"http://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json";

@interface WikipediaAPI ()
@property(nonatomic, strong) NSURLSession *session;
@end

@implementation WikipediaAPI

- (instancetype)init {
    
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];
    }
    
    return self;
}

-(void)articleForTitle:(NSString *)title withCompletion:(CompletionHandler)completion {
    NSString *url = [NSString stringWithFormat:@"%@&titles=%@", kWikipediaAPI, escapeString(title)];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, error);
        }
        NSError *jsonError = nil;
        NSDictionary *tree = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError][@"query"][@"pages"];
        NSString *firstKey = tree.allKeys.firstObject;
        
        NSString *result = [tree[firstKey][@"revisions"] firstObject][@"*"];
        
        NSError *regexError = nil;
        NSString *regexString = @"([^\{\\}]\\w*)(?=\\})"; // @"[^\\{\\}]\\w*?=\\}"; //@"([^{}]\\w*)(?=})";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&regexError];
        
        NSArray *matches = [expression matchesInString:result options:NSMatchingAnchored range:NSMakeRange(0, result.length)];
        
        [expression enumerateMatchesInString:result options:NSMatchingAnchored range:NSRangeFromString(result) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSLog(@"MATCH: %@", result.description);
        }];
                                           
    }];
    
    [dataTask resume];
}

@end
