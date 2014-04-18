//
//  SuggestionCell.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "SuggestionCell.h"

@implementation SuggestionCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (! (self = [super initWithCoder:aDecoder]) ) {
        return nil;
    }
    
    self.layer.borderColor = [[UIColor colorWithRed:0.00f green:(122.0/255.0) blue:1.00f alpha:1.00f] CGColor];
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 14.0;
    
    return self;
}

#pragma mark - Appearance state
-(void)setHighlighted:(BOOL)highlighted {
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:0.00f green:(122.0/255.0) blue:1.00f alpha:1.00f];
        self.textLabel.textColor = [UIColor whiteColor];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor colorWithRed:0.00f green:(122.0/255.0) blue:1.00f alpha:1.00f];
    }
}

-(void)setSelected:(BOOL)selected {
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0.00f green:(122.0/255.0) blue:1.00f alpha:1.00f];
        self.textLabel.textColor = [UIColor whiteColor];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor colorWithRed:0.00f green:(122.0/255.0) blue:1.00f alpha:1.00f];
    }
}

@end
