//
//  BingSearchResult.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "BingSearchResult.h"

@interface BingSearchResult ()
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong, readwrite) NSString *descriptionText;
@property (nonatomic, assign, readwrite) int64_t uid;
@property (nonatomic, assign, readwrite) BingSearchResultType resultType;
@end

@implementation BingSearchResult

+(instancetype)resultWithDictionary:(NSDictionary *)dictionary {
    BingSearchResult *result = [BingSearchResult new];
    result.title = dictionary[@"Title"];
    result.url = [NSURL URLWithString:dictionary[@"Url"]];
    result.descriptionText = dictionary[@"Description"];
    result.uid = [dictionary[@"ID"] integerValue];
    
    NSString *host = result.url.host;
    
    if ([host isEqualToString:@"en.wikipedia.org"]) {
        result.resultType = ResultTypeWikipedia;
    }
    else if ([host isEqualToString:@"twitter.com"]) {
        result.resultType = ResultTypeTwitter;
    }
    else {
        result.resultType = ResultTypeBasic;
    }
    
    return result;
}

@end
