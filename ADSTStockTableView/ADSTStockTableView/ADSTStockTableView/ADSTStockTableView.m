//
//  ADSTStockTableView.m
//  ADSTStockTableView
//
//  Created by andysxing on 2020/5/13.
//  Copyright © 2020 andysxing. All rights reserved.
//

#import "ADSTStockTableView.h"
#import "ADSTStockScrollView.h"
#import "ADSTStockTableViewCell.h"
static NSString* const CellID = @"cellID";

@interface ADSTStockTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    //左边最后一次滑动x坐标，滚动列表视图使用
    CGFloat _lastRightScrollX;
    
    //右边最后一次滑动x坐标，滚动列表视图使用
    CGFloat _lastLeftScrollX;
    
}


/// 整体列表
@property(nonatomic,readwrite,strong) UITableView* stockTableView;

/// 右边头部
@property(nonatomic,readwrite,strong) ADSTStockScrollView* rightHeadScrollView;

/// 左边列表
@property(nonatomic,readwrite,strong) ADSTStockScrollView* leftHeadScrollView;

@end

@implementation ADSTStockTableView

#pragma mark - Init/Override

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.stockTableView.backgroundColor = backgroundColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _stockTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark - Setup

- (void)setupView{
    [self addSubview:self.stockTableView];
}

#pragma mark - Public

- (void)reloadStockView{
    [self.stockTableView reloadData];
    [self scrollToLastScrollX];
}

- (void)reloadStockViewFromRow:(NSUInteger)row{
    [self.stockTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self scrollToLastScrollX];
}

- (void)scrollStockViewToRow:(NSUInteger)row{
    [self.stockTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (UITableView*)tStockTableView{
    return _stockTableView;
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSParameterAssert(self.dataSource);
    
    ADSTStockTableViewCell* cell = (ADSTStockTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell) {
        
        cell = [[ADSTStockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.rightContentScrollView.delegate = self;
        cell.leftContentScrollView.delegate = self;
        
        if([self.dataSource respondsToSelector:@selector(cellLeftContentForStockView:rowPath:)]){
            [cell setLeftContentView:[self.dataSource cellLeftContentForStockView:self rowPath:indexPath.row]];
        }
        
        if([self.dataSource respondsToSelector:@selector(cellFixedViewForStockView:rowPath:)]){
            [cell setFixedView:[self.dataSource cellFixedViewForStockView:self rowPath:indexPath.row]];
        }
        
        if([self.dataSource respondsToSelector:@selector(cellRightContentForStockView:rowPath:)]){
            [cell setRightContentView:[self.dataSource cellRightContentForStockView:self rowPath:indexPath.row]];
        }
        
        __weak typeof(self) weakSelf = self;
        [cell setRightContentTapBlock:^(ADSTStockTableViewCell* cell){
            __strong typeof(self) strongSelf = weakSelf;
            NSIndexPath* indexPath = [tableView indexPathForCell:cell];
            if ([strongSelf.delegate respondsToSelector:@selector(didSelect:rowPath:)]) {
                [strongSelf.delegate didSelect:strongSelf rowPath:indexPath.row];
            }
        }];
        
    }
    
    if([self.dataSource respondsToSelector:@selector(updateCellStockView: fixedView: leftContentView: rightContentView:rowPath:)]){
        [self.dataSource updateCellStockView:self fixedView:cell.fixedView leftContentView:cell.leftContentView rightContentView:cell.rightContentView rowPath:indexPath.row];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(heightForCell:indexPath:)]){
        return [self.delegate heightForCell:self indexPath:indexPath];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSParameterAssert(self.dataSource);
    if([self.dataSource respondsToSelector:@selector(countForStockView:)]){
        return [self.dataSource countForStockView:self];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self.delegate respondsToSelector:@selector(heightForHeadView:)]){
        return [self.delegate heightForHeadView:self];
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat fixediewWidth = 0.0f;
    CGFloat fixediewx = 0.0f;
    CGFloat headHeight = 0.0f;
    
    if([self.delegate respondsToSelector:@selector(headFixedView:)]){
        UIView* fixediew = [self.delegate headFixedView:self];
        [headerView addSubview:fixediew];
        fixediewWidth = CGRectGetWidth(fixediew.frame);
        fixediewx = CGRectGetMinX(fixediew.frame);
    }
    
    if([self.delegate respondsToSelector:@selector(heightForHeadView:)]){
        headHeight =  [self.delegate heightForHeadView:self];
    }
    
    [headerView addSubview:self.rightHeadScrollView];
    [headerView addSubview:self.leftHeadScrollView];
    
    self.rightHeadScrollView.frame = CGRectMake(fixediewx+fixediewWidth,0,CGRectGetWidth(self.frame) - fixediewWidth-fixediewx,headHeight);
    self.leftHeadScrollView.frame = CGRectMake(0,0,CGRectGetWidth(self.frame) - fixediewWidth-fixediewx,headHeight);
    
    if([self.delegate respondsToSelector:@selector(headLeftView:)] && [self.delegate respondsToSelector:@selector(headRightView:)] ){
        UIView* rightView = [self.delegate headRightView:self];
        [self.rightHeadScrollView addSubview:rightView];
        
        UIView* leftView = [self.delegate headLeftView:self];
        [self.leftHeadScrollView addSubview:leftView];
        
        self.rightHeadScrollView.contentSize = CGSizeMake(CGRectGetWidth(rightView.frame), headHeight);
        self.leftHeadScrollView.contentSize = CGSizeMake(CGRectGetWidth(leftView.frame), headHeight);
        
        [self.leftHeadScrollView setContentOffset:CGPointMake(CGRectGetWidth(leftView.frame)-(CGRectGetWidth(self.frame) - fixediewWidth-fixediewx), 0) animated:NO];
    }
    
    return headerView;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.stockTableView){
        [self scrollToLastScrollX];
    }else if(scrollView == self.rightHeadScrollView || scrollView == self.leftHeadScrollView){
        [self linkAgeScrollView:scrollView];
    }else{
        [self linkAgeScrollView:scrollView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.stockTableView){
        [self scrollToLastScrollX];
    }else if(scrollView == self.rightHeadScrollView || scrollView == self.leftHeadScrollView){
        [self linkAgeScrollView:scrollView];
    }else{
        [self linkAgeScrollView:scrollView];
    }
}

#pragma mark - Control Scroll

- (void)linkAgeScrollView:(UIScrollView*)sender{
    NSArray* visibleCells = [self.stockTableView visibleCells];
    ADSTStockScrollView * scrollView = (ADSTStockScrollView *)sender;
    CGFloat  scrollViewCW = scrollView.contentSize.width;
    CGFloat  scrollViewFW = scrollView.frame.size.width;
    for (ADSTStockTableViewCell* cell in visibleCells) {
        if (cell.rightContentScrollView != sender) {
            CGFloat scrollX = sender.contentOffset.x;
            if(scrollView.viewType == ADSTStockScrollViewLeft){ //滑动得组件为左边时，右边滑动取反向
                scrollX = scrollViewCW-scrollViewFW-sender.contentOffset.x;
            }
            [self updateScrollView:cell.rightContentScrollView toLastScrollX:scrollX];
        }
        if (cell.leftContentScrollView != sender) {
            CGFloat scrollX = sender.contentOffset.x;
            if(scrollView.viewType == ADSTStockScrollViewRight){ //滑动得组件为右边时，左边滑动取反向
                scrollX = scrollViewCW-scrollViewFW-sender.contentOffset.x ;
            }
            [self updateScrollView:cell.leftContentScrollView toLastScrollX:scrollX];
        }
    }
    //内容滑动视图需要更新头部
    if (sender != self.rightHeadScrollView) {
        CGFloat scrollX = sender.contentOffset.x;
        if(scrollView.viewType == ADSTStockScrollViewLeft){
            scrollX = scrollViewCW-scrollViewFW-sender.contentOffset.x ;
        }
        [self updateScrollView:self.rightHeadScrollView toLastScrollX:scrollX];
    }
    
    if (sender != self.leftHeadScrollView) {
        CGFloat scrollX = sender.contentOffset.x;
        if(scrollView.viewType == ADSTStockScrollViewRight){
            scrollX = scrollViewCW-scrollViewFW-sender.contentOffset.x ;
        }
        [self updateScrollView:self.leftHeadScrollView toLastScrollX:scrollX];
    }
    //stockTableView 需要两个值进行重绘更多cell偏移
    _lastRightScrollX = self.rightHeadScrollView.contentOffset.x;
    _lastLeftScrollX = self.leftHeadScrollView.contentOffset.x;
}

- (void)scrollToLastScrollX{
    NSArray* visibleCells = [self.stockTableView visibleCells];
    for (ADSTStockTableViewCell* cell in visibleCells) {
        [self updateScrollView:cell.rightContentScrollView toLastScrollX:_lastRightScrollX];
        [self updateScrollView:cell.leftContentScrollView toLastScrollX:_lastLeftScrollX];
    }
    [self updateScrollView:self.rightHeadScrollView toLastScrollX:_lastRightScrollX];
    [self updateScrollView:self.leftHeadScrollView toLastScrollX:_lastLeftScrollX];
}

- (void)updateScrollView:(UIScrollView*)scrollView toLastScrollX:(CGFloat)scrollX{
    //先取消代理避免多次调用，后续在重新注册代理
    scrollView.delegate = nil;
    [scrollView setContentOffset:CGPointMake(scrollX, 0) animated:NO];
    scrollView.delegate = self;
}
#pragma mark - Property Get

- (UITableView*)stockTableView{
    if(_stockTableView != nil){
        return _stockTableView;
    }
    _stockTableView = [UITableView new];
    _stockTableView.dataSource = self;
    _stockTableView.delegate = self;
    _stockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _stockTableView;
}

- (ADSTStockScrollView*)rightHeadScrollView{
    if(_rightHeadScrollView != nil){
        return _rightHeadScrollView;
    }
    _rightHeadScrollView = [ADSTStockScrollView new];
    _rightHeadScrollView.showsVerticalScrollIndicator = NO;
    _rightHeadScrollView.viewType = ADSTStockScrollViewRight;
    _rightHeadScrollView.showsHorizontalScrollIndicator = NO;
    _rightHeadScrollView.delegate = self;
    return _rightHeadScrollView;
}

- (ADSTStockScrollView*)leftHeadScrollView{
    if(_leftHeadScrollView != nil){
        return _leftHeadScrollView;
    }
    _leftHeadScrollView = [ADSTStockScrollView new];
    _leftHeadScrollView.viewType = ADSTStockScrollViewLeft;
    _leftHeadScrollView.showsVerticalScrollIndicator = NO;
    _leftHeadScrollView.showsHorizontalScrollIndicator = NO;
    _leftHeadScrollView.delegate = self;
    return _leftHeadScrollView;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
