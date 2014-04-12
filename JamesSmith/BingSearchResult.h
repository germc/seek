//
//  BingSearchResult.h
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BingSearchResult : NSObject

@property (nonatomic, strong, readonly)NSString *title;
@property (nonatomic, strong, readonly)NSURL *url;
@property (nonatomic, strong, readonly)NSString *descriptionText;
@property (nonatomic, assign, readonly)int64_t uid;

+ (instancetype)resultWithDictionary:(NSDictionary *)dictionary;

@end
