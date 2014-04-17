//
//  BingImageSearchResult.h
//  JamesSmith
//
//  Created by admin on 4/16/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

@import Foundation;

@interface BingImageSearchResult : NSObject
@property (nonatomic, strong, readonly) NSURL *sourceURL;
@property (nonatomic, strong, readonly) NSURL *fullSizeURL;
@property (nonatomic, strong, readonly) NSURL *thumbnailURL;

+(instancetype)searchResultWithDictionary:(NSDictionary *)dictionary;

@end
