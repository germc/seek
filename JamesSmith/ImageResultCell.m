//
//  ImageResultCell.m
//  JamesSmith
//
//  Created by admin on 4/16/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "ImageResultCell.h"

@implementation ImageResultCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    if ( !(self = [super initWithFrame:frame]) ) {
        return nil;
    }
    self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    
    return self;
}

@end
