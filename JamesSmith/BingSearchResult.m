//
//  BingSearchResult.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "BingSearchResult.h"

@interface BingSearchResult ()
@property (nonatomic, strong, readwrite)NSString *title;
@property (nonatomic, strong, readwrite)NSURL *url;
@property (nonatomic, strong, readwrite)NSString *descriptionText;
@property (nonatomic, assign, readwrite)int64_t uid;
@end

@implementation BingSearchResult

+(instancetype)resultWithDictionary:(NSDictionary *)dictionary {
    BingSearchResult *result = [BingSearchResult new];
    result.title = dictionary[@"Title"];
    result.url = [NSURL URLWithString:dictionary[@"Url"]];
    result.descriptionText = dictionary[@"Description"];
    result.uid = [dictionary[@"ID"] integerValue];
    return result;
}

@end
