//
//  NSArray+reversedArray.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "NSArray+reversedArray.h"

@implementation NSArray (reversedArray)

-(NSArray *)reversedArray {
    
    NSMutableArray *array = [NSMutableArray new];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    
    for (id obj in enumerator) {
        [array addObject:obj];
    }
    
    return array;
}

@end
