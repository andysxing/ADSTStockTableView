//
//  ADSTStockTableViewCell.h
//  ADSTStockTableView
//
//  Created by andysxing on 2020/5/13.
//  Copyright © 2020 andysxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADSTStockTableViewCell : UITableViewCell


/// Cell的左右可滑动的ScrollView,设置成ReadOnly，滚动代理由Table来实现
@property(nonatomic,readonly,strong)UIScrollView* rightContentScrollView;

/// Cell的左右可滑动的ScrollView,设置成ReadOnly，滚动代理由Table来实现
@property(nonatomic,readonly,strong)UIScrollView* leftContentScrollView;



/**
 右边内容部分的点击事件Block
 */
@property(nonatomic,readwrite,copy)void (^rightContentTapBlock)(ADSTStockTableViewCell* cell);


/**
 设置左边的自定义View
 */
@property(nonatomic,readwrite,strong)UIView* fixedView;

/**
 设置右边可以滑动自定义View
 内部实现添加到滚动视图
 */
@property(nonatomic,readwrite,strong)UIView* rightContentView;

/**
设置左边可以滑动自定义View
内部实现添加到滚动视图
*/
@property(nonatomic,readwrite,strong)UIView* leftContentView;
@end

NS_ASSUME_NONNULL_END
