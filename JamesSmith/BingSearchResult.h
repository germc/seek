//
//  BingSearchResult.h
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

@import Foundation;

@interface BingSearchResult : NSObject

typedef NS_ENUM (NSUInteger, BingSearchResultType) {
    ResultTypeBasic,
    ResultTypeWikipedia,
    ResultTypeTwitter,
};

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSString *descriptionText;
@property (nonatomic, assign, readonly) int64_t uid;
@property (nonatomic, assign, readonly) BingSearchResultType resultType;

+(instancetype)resultWithDictionary:(NSDictionary *)dictionary;

@end
