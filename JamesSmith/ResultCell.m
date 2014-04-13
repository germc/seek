//
//  ResultCell.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "ResultCell.h"
#import "UIView+AutoLayout.h"

#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        10.0f

@interface ResultCell ()
@property (nonatomic, assign)BOOL didSetupConstraints;
@end

@implementation ResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel newAutoLayoutView];
        [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.titleLabel setNumberOfLines:0];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setTextColor:[UIColor colorWithRed:0.00f green:(122.0/255.0) blue:1.00f alpha:1.00f]];
        
        self.linkLabel = [UILabel newAutoLayoutView];
        [self.linkLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.linkLabel setNumberOfLines:1];
        [self.linkLabel setTextAlignment:NSTextAlignmentLeft];
        [self.linkLabel setTextColor:[UIColor colorWithRed:0.00f green:0.40f blue:0.11f alpha:1.00f]];
        
        self.descriptionLabel = [UILabel newAutoLayoutView];
        [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.descriptionLabel setNumberOfLines:0];
        [self.descriptionLabel setTextAlignment:NSTextAlignmentLeft];
        [self.descriptionLabel setTextColor:[UIColor darkGrayColor]];
        
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descriptionLabel];
        [self.contentView addSubview:self.linkLabel];
        
        [self updateFonts];
    }
    
    return self;
}


-(void)updateConstraints {
    [super updateConstraints];
    
    if (self.didSetupConstraints) {
        return;
    }
    
    // Title Label
    [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.titleLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
  
    
    // Link label
    [self.linkLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [self.linkLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
    
    [self.linkLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kLabelVerticalInsets/2];
    //[self.linkLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.descriptionLabel withOffset:kLabelVerticalInsets];
    
    // Description label
    [self.descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.linkLabel withOffset:kLabelVerticalInsets/2 relation:NSLayoutRelationGreaterThanOrEqual];
    
    [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.descriptionLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
    
    self.didSetupConstraints = YES;

    
}

 
-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.frame);
}

-(void)updateFonts {
    UIFont *titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:20.0f];
    UIFont *descriptionFont = [UIFont fontWithName:@"AvenirNext" size:17.0];
    UIFont *linkFont = [UIFont fontWithName:@"AvenirNext-Italic" size:17.0];
    
    self.titleLabel.font = titleFont;
    self.descriptionLabel.font = descriptionFont;
    self.linkLabel.font = linkFont;
}

@end
