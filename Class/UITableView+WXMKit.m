//
//  UITableView+WXMKit.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/23.
//  Copyright © 2019 wxm. All rights reserved.
//
#define WXMCellIdentifier @"WXMCellIdentifier"
#define WXMPreventCrashBegin  @try {
#define WXMPreventCrashEnd     } @catch (NSException *exception) {} @finally {}
#import "UITableView+WXMKit.h"

@implementation UITableView (WXMKit)

- (void)wc_updateWithBlock:(void (^)(UITableView *tableView))block {
    [self beginUpdates];
    block(self);
    [self endUpdates];
}

/** 滚动到第一个cell */
- (void)wc_scrollToFirstCellWithAnimated:(BOOL)animated {
    if (self.sectionCount > 1 && [self rowCountOfSetion:0] > 1) {
        [self wc_scrollToRow:0
                   inSection:0
            atScrollPosition:UITableViewScrollPositionTop
                    animated:animated];
    }
}

/** 滚动到最后一个cell */
- (void)wc_scrollToLastCellWithAnimated:(BOOL)animated {
    NSInteger section = MAX(self.sectionCount - 1, 0);
    NSInteger row = MAX([self rowCountOfSetion:section] - 1, 0);
    [self wc_scrollToRow:row
               inSection:section
        atScrollPosition:UITableViewScrollPositionBottom
                animated:animated];
}

/** 滚动到某个cell */
- (void)wc_scrollToRow:(NSUInteger)row
             inSection:(NSUInteger)section
      atScrollPosition:(UITableViewScrollPosition)scrollPosition
              animated:(BOOL)animated {
    
    if (self.sectionCount > section && [self rowCountOfSetion:section] > row) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

/** 刷新cell */
- (void)wc_reloadRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (self.sectionCount > section && [self rowCountOfSetion:section] > row) {
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
    }
}

- (void)wc_reloadSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.sectionCount > section) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [self reloadSections:indexSet withRowAnimation:animation];
    }
}

- (void)wc_reloadRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toReload = [NSIndexPath indexPathForRow:row inSection:section];
    [self wc_reloadRowAtIndexPath:toReload withRowAnimation:animation];
}

/** 插入cell */
- (void)wc_insertRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation {
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)wc_insertRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation {
    WXMPreventCrashBegin
    NSIndexPath *toInsert = [NSIndexPath indexPathForRow:row inSection:section];
    [self wc_insertRowAtIndexPath:toInsert withRowAnimation:animation];
    WXMPreventCrashEnd
}

- (void)wc_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    WXMPreventCrashBegin
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self insertSections:sections withRowAnimation:animation];
    WXMPreventCrashEnd
}

/** 删除 */
- (void)wc_deleteRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (self.sectionCount > section && [self rowCountOfSetion:section] > row) {
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
    }
}

- (void)wc_deleteRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toDelete = [NSIndexPath indexPathForRow:row inSection:section];
    [self wc_deleteRowAtIndexPath:toDelete withRowAnimation:animation];
}

- (void)wc_deleteSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.sectionCount > section) {
        NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
        [self deleteSections:sections withRowAnimation:animation];
    }
}

- (void)wc_clearSelectedRowsAnimated:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:path animated:animated];
    }];
}

/** 获取有几个组 */
- (NSInteger)sectionCount {
    return MAX(self.numberOfSections, 0);
}

/** 获取该组有几行 */
- (NSInteger)rowCountOfSetion:(NSInteger)section {
    return MAX([self numberOfRowsInSection:section], 0);
}

@end
