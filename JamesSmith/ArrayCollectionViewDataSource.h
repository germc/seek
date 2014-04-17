//
//  ArrayCollectionViewDataSource.h
//  JamesSmith
//
//  Created by admin on 4/16/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

@import Foundation;
@class ImageResultCell;
typedef void (^ConfigureCell)(ImageResultCell *cell, id arrayItem);

@interface ArrayCollectionViewDataSource : NSObject <UICollectionViewDataSource>

-(instancetype)initWithItems:(NSArray *)items
              cellIdentifier:(NSString *)cellIdentifier
          configureCellBlock:(ConfigureCell)configureCell;

@end
