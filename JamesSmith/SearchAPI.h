//
//  SearchAPI.h
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

@import Foundation;

/* Completion Handler is called on the main thread */
typedef void (^SearchCompletionHandler)(NSArray *results, NSError *error);

@interface SearchAPI : NSObject

-(void)searchWithQuery:(NSString *)query completion:(SearchCompletionHandler)completion;

@end
