//
//  AutocompleteAPI.h
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

@import Foundation;

typedef void (^QueryCompletionHandler)(NSArray *results, NSError *error);

@interface AutocompleteAPI : NSObject

-(void)suggestionsForQuery:(NSString *)query withCompletionHandler:(QueryCompletionHandler)completion;

@end
