//
//  ADSTStockScrollView.m
//  ADSTStockTableView
//
//  Created by andysxing on 2020/5/13.
//  Copyright © 2020 andysxing. All rights reserved.
//

#import "ADSTStockScrollView.h"

@implementation ADSTStockScrollView

/**
 重写touchesShouldCancelInContentView  Button作为子View时，也能正常滑动
 @param view UIView
 @return 如果返回YES 正常滑动
 */
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
