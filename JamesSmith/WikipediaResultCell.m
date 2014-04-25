//
//  WikipediaResultCellTableViewCell.m
//  Seek
//
//  Created by admin on 4/24/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "WikipediaResultCell.h"

@implementation WikipediaResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
