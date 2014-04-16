//
//  ArrayDataSource.m
//  JamesSmith
//
//  Created by admin on 4/16/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "ArrayTableViewDataSource.h"

@interface ArrayTableViewDataSource ()
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, weak) NSArray *items;
@property (nonatomic, assign) ConfigureCell configureCell;
@end

@implementation ArrayTableViewDataSource

#pragma mark - Initializers
-(instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(ConfigureCell)configureCell {
    
    if ( !(self = [super init]) ) {
        return nil;
    }
    self.items = items;
    self.cellIdentifier = [cellIdentifier copy];
    self.configureCell = configureCell;
    
    return self;
}

#pragma mark - UITableView Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = self.items[indexPath.row];
    self.configureCell(cell, item);
    
    return cell;
}

@end
