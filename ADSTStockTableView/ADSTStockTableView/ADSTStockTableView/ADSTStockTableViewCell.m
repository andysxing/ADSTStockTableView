//
//  ADSTStockTableViewCell.m
//  ADSTStockTableView
//
//  Created by andysxing on 2020/5/13.
//  Copyright © 2020 andysxing. All rights reserved.
//

#import "ADSTStockTableViewCell.h"
#import "ADSTStockScrollView.h"

@interface ADSTStockTableViewCell()<UIScrollViewDelegate>{
    @private
    ADSTStockScrollView* _rightContentScrollView;
    ADSTStockScrollView* _leftContentScrollView;
}

@end

@implementation ADSTStockTableViewCell

#pragma mark - Init

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupDefaultSettings];
        [self setupView];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
   
//    self.fixedView.frame = CGRectMake((self.frame.size.width-100)/2, 0, CGRectGetWidth(self.fixedView.frame), CGRectGetHeight(self.fixedView.frame));
     CGFloat fixedX = self.fixedView.frame.origin.x;
    
    id tempDelegate = _rightContentScrollView.delegate;
    id templeftDelegate = _rightContentScrollView.delegate;
    _rightContentScrollView.delegate = nil;//Do not send delegate message
    
    _rightContentScrollView.frame = CGRectMake(CGRectGetWidth(self.fixedView.frame)+fixedX, 0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.fixedView.frame)-fixedX, CGRectGetHeight(self.rightContentView.frame));
    _rightContentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.rightContentView.frame), CGRectGetHeight(self.rightContentView.frame));
    
    
    _leftContentScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.fixedView.frame)-fixedX, CGRectGetHeight(self.leftContentView.frame));
    _leftContentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.leftContentView.frame), CGRectGetHeight(self.leftContentView.frame));
     _leftContentScrollView.delegate = nil;//Do not send delegate message
    
    [_leftContentScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.leftContentView.frame)-fixedX, 0) animated:NO];
    
    _rightContentScrollView.delegate = tempDelegate;//Restore deleagte
    _leftContentScrollView.delegate = templeftDelegate;//Restore deleagte
}

#pragma mark - Setup

- (void)setupDefaultSettings{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupView{
    [self.contentView addSubview:self.rightContentScrollView];
    [self.contentView addSubview:self.leftContentScrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightContentScrollView addGestureRecognizer:tapGesture];
}

#pragma mark - Tap

- (void)tapAction:(UITapGestureRecognizer *)gesture{
//    if (self.rightContentTapBlock) {
//        self.rightContentTapBlock(self);
//    }
}

#pragma mark - Public

- (UIScrollView*)rightContentScrollView{
    if (_rightContentScrollView != nil) {
        return _rightContentScrollView;
    }
    _rightContentScrollView = [ADSTStockScrollView new];
    _rightContentScrollView.viewType= ADSTStockScrollViewRight;
    _rightContentScrollView.canCancelContentTouches = YES;
    _rightContentScrollView.showsVerticalScrollIndicator = NO;
    _rightContentScrollView.showsHorizontalScrollIndicator = NO;
    return _rightContentScrollView;
}


- (UIScrollView*)leftContentScrollView{
    if (_leftContentScrollView != nil) {
        return _leftContentScrollView;
    }
    _leftContentScrollView = [ADSTStockScrollView new];
    _leftContentScrollView.viewType = ADSTStockScrollViewLeft;
    _leftContentScrollView.canCancelContentTouches = YES;
    _leftContentScrollView.showsVerticalScrollIndicator = NO;
    _leftContentScrollView.showsHorizontalScrollIndicator = NO;
    return _leftContentScrollView;
}

- (void)setFixedView:(UIView *)fixedView{
    if(_fixedView){
          [_fixedView removeFromSuperview];
      }
      [self.contentView addSubview:fixedView];
      _fixedView = fixedView;
      [self setNeedsLayout];
}

- (void)setRightContentView:(UIView*)contentView{
    if(_rightContentView){
        [_rightContentView removeFromSuperview];
    }
    [_rightContentScrollView addSubview:contentView];
    
    _rightContentView = contentView;
    
    [self setNeedsLayout];
}

- (void)setLeftContentView:(UIView*)contentView{
    if(_leftContentView){
        [_leftContentView removeFromSuperview];
    }
    [_leftContentScrollView addSubview:contentView];
    
    _leftContentView = contentView;
    
    [self setNeedsLayout];
}


@end
