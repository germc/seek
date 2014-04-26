//
//  WikipediaAPI.h
//  Seek
//
//  Created by Jamie Smith on 4/25/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionHandler)(NSArray *results, NSError *error);

@interface WikipediaAPI : NSObject

- (void) articleForTitle:(NSString *)title withCompletion:(CompletionHandler)completion;

@end
