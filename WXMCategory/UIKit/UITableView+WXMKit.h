//
//  UITableView+WXMKit.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/23.
//  Copyright © 2019 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (WXMKit)

- (void)updateWithBlock:(void (^)(UITableView *tableView))block;


- (void)scrollToRow:(NSUInteger)row
          inSection:(NSUInteger)section
   atScrollPosition:(UITableViewScrollPosition)scrollPosition
           animated:(BOOL)animated;


- (void)insertRow:(NSUInteger)row
        inSection:(NSUInteger)section
 withRowAnimation:(UITableViewRowAnimation)animation;


- (void)reloadRow:(NSUInteger)row
        inSection:(NSUInteger)section
 withRowAnimation:(UITableViewRowAnimation)animation;


- (void)deleteRow:(NSUInteger)row
        inSection:(NSUInteger)section
 withRowAnimation:(UITableViewRowAnimation)animation;


- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath
            withRowAnimation:(UITableViewRowAnimation)animation;


- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath
            withRowAnimation:(UITableViewRowAnimation)animation;


- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath
            withRowAnimation:(UITableViewRowAnimation)animation;


- (void)insertSection:(NSUInteger)section
     withRowAnimation:(UITableViewRowAnimation)animation;


- (void)deleteSection:(NSUInteger)section
     withRowAnimation:(UITableViewRowAnimation)animation;


- (void)reloadSection:(NSUInteger)section
     withRowAnimation:(UITableViewRowAnimation)animation;


- (void)clearSelectedRowsAnimated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
