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

/** 动画 */
- (void)wc_updateWithBlock:(void (^)(UITableView *tableView))block;

/** 滚动到第一个cell */
- (void)wc_scrollToFirstCellWithAnimated:(BOOL)animated;

/** 滚动到最后一个cell */
- (void)wc_scrollToLastCellWithAnimated:(BOOL)animated;

/** 滚动到某个cell */
- (void)wc_scrollToRow:(NSUInteger)row
             inSection:(NSUInteger)section
      atScrollPosition:(UITableViewScrollPosition)scrollPosition
              animated:(BOOL)animated;

/** 插入row section */
- (void)wc_insertRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/** 插入indexPath */
- (void)wc_insertRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation;

/** 插入组 */
- (void)wc_insertSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation;

/** 刷新row section */
- (void)wc_reloadRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/** 刷新indexPath */
- (void)wc_reloadRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation;

/** 刷新组 */
- (void)wc_reloadSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation;

/** 删除row section */
- (void)wc_deleteRow:(NSUInteger)row
           inSection:(NSUInteger)section
    withRowAnimation:(UITableViewRowAnimation)animation;

/** 删除indexPath */
- (void)wc_deleteRowAtIndexPath:(NSIndexPath *)indexPath
               withRowAnimation:(UITableViewRowAnimation)animation;

/** 删除组 */
- (void)wc_deleteSection:(NSUInteger)section
        withRowAnimation:(UITableViewRowAnimation)animation;

/** 删除全部 */
- (void)wc_clearSelectedRowsAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
