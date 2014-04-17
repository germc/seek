//
//  BingImageSearchResult.m
//  JamesSmith
//
//  Created by admin on 4/16/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "BingImageSearchResult.h"

@interface BingImageSearchResult ()
@property (nonatomic, strong, readwrite) NSURL *sourceURL;
@property (nonatomic, strong, readwrite) NSURL *fullSizeURL;
@property (nonatomic, strong, readwrite) NSURL *thumbnailURL;
@end

@implementation BingImageSearchResult

+(instancetype)searchResultWithDictionary:(NSDictionary *)dictionary {
    BingImageSearchResult *result = [BingImageSearchResult new];
    result.sourceURL = [NSURL URLWithString:dictionary[@"SourceUrl"]];
    result.fullSizeURL = [NSURL URLWithString:dictionary[@"MediaUrl"]];
    result.thumbnailURL = [NSURL URLWithString:dictionary[@"Thumbnail"][@"MediaUrl"]];
    
    return result;
}

@end
