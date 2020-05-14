//
//  ADSTStockTableView.h
//  ADSTStockTableView
//
//  Created by andysxing on 2020/5/13.
//  Copyright © 2020 andysxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADSTStockTableView ;

@protocol ADSTStockTableDelegate <NSObject>

@optional
/**
 表固定不动列上的自定义View

 @param stockView ADSTStockTableView
 @return 自定义View
 */
- (UIView*)headFixedView:(ADSTStockTableView*)stockView;

/**
 左边可滑动头部View

 @param stockView ADSTStockTableView
 @return 自定义View
 */
- (UIView*)headLeftView:(ADSTStockTableView*)stockView;

/**
 右边可滑动头部View

 @param stockView ADSTStockTableView
 @return 自定义View
 */
- (UIView*)headRightView:(ADSTStockTableView*)stockView;

/**
 头部headView共用这个高度

 @param stockView ADSTStockTableView
 @return 返回指定高度
 */
- (CGFloat)heightForHeadView:(ADSTStockTableView*)stockView;

/**
 内容部分高度，左边和右边共用这个高度

 @param stockView ADSTStockTableView
 @return 返回指定高度
 */
- (CGFloat)heightForCell:(ADSTStockTableView*)stockView indexPath:(NSIndexPath *)indexPath;

/**
 点击行事件

 @param stockView ADSTStockTableView
 @param row 当前行的索引值
 */
- (void)didSelect:(ADSTStockTableView*)stockView rowPath:(NSUInteger)row;

@end

@protocol ADSTStockTableDataSource <NSObject>

@required

/**
 控件内容的总行数

 @param stockView ADSTStockTableView
 @return 总行数
 */
- (NSUInteger)countForStockView:(ADSTStockTableView*)stockView;

/**
 FixedView列每一行自定义View

 @param stockView ADSTStockTableView
 @param row 当前行的索引值
 @return 返回自定义View
 */
- (UIView*)cellFixedViewForStockView:(ADSTStockTableView*)stockView rowPath:(NSUInteger)row;

/**
 左边内容可滑动自定义View

 @param stockView ADSTStockTableView
 @param row 当前行的索引值
 @return 返回自定义View
 */
- (UIView*)cellLeftContentForStockView:(ADSTStockTableView*)stockView rowPath:(NSUInteger)row;


/**
 右边内容可滑动自定义View

 @param stockView ADSTStockTableView
 @param row 当前行的索引值
 @return 返回自定义View
 */
- (UIView*)cellRightContentForStockView:(ADSTStockTableView*)stockView rowPath:(NSUInteger)row;



///  更新列表cell的数据
/// @param stockView ADSTStockTableView
/// @param fixedView  固定列
/// @param leftView 左边滚动视图
/// @param rightView 右边滚动视图
/// @param row 当前行的索引值
- (void)updateCellStockView:(ADSTStockTableView*)stockView fixedView:(UIView*)fixedView leftContentView:(UIView*)leftView rightContentView:(UIView*)rightView rowPath:(NSUInteger)row;



@end

@interface ADSTStockTableView : UIView

@property(nonatomic,readwrite,weak)id<ADSTStockTableDataSource> dataSource;


@property(nonatomic,readwrite,weak)id<ADSTStockTableDelegate> delegate;


/**
 具体实现的UITableView,代理由内部实现
 */
@property(nonatomic,readonly,weak)UITableView* tStockTableView;

/**
 刷新控件所有元素
 */
- (void)reloadStockView;

/**
 刷新行的样式

 @param row 指定行的索引值
 */
- (void)reloadStockViewFromRow:(NSUInteger)row;

/**
 滚动到指定行

 @param row 指定行的索引值
 */
- (void)scrollStockViewToRow:(NSUInteger)row;

@end

NS_ASSUME_NONNULL_END
