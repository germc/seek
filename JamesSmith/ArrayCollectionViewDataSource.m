//
//  ArrayCollectionViewDataSource.m
//  JamesSmith
//
//  Created by admin on 4/16/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "ArrayCollectionViewDataSource.h"

#import "ImageResultCell.h"

@interface ArrayCollectionViewDataSource ()
@property (nonatomic, weak) NSArray *items;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, copy) ConfigureCell configureCell;
@end

@implementation ArrayCollectionViewDataSource

-(instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(ConfigureCell)configureCell {
    
    if ( !(self = [super init])) {
        return nil;
    }
    self.items = items;
    self.cellIdentifier = [cellIdentifier copy];
    self.configureCell = configureCell;
    
    return self;
}

#pragma mark - CollectionView Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    cell.imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    [cell.contentView addSubview:cell.imageView];
    id item = self.items[indexPath.item];
    self.configureCell(cell, item);
    
    return cell;
}

@end
