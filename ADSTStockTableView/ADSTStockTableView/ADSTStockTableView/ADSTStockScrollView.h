//
//  ADSTStockScrollView.h
//  ADSTStockTableView
//
//  Created by andysxing on 2020/5/13.
//  Copyright © 2020 andysxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    ADSTStockScrollViewLeft,
    ADSTStockScrollViewRight
} ADSTStockScrollViewType;

@interface ADSTStockScrollView : UIScrollView

@property (nonatomic , assign) ADSTStockScrollViewType viewType;

@end

NS_ASSUME_NONNULL_END
