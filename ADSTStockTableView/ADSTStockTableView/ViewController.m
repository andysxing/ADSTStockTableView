//
//  ViewController.m
//  ADSTStockTableView
//
//  Created by andysxing on 2020/5/13.
//  Copyright © 2020 andysxing. All rights reserved.
//

#import "ViewController.h"
#import "ADSTStockTableView.h"

@interface ViewController ()<ADSTStockTableDataSource,ADSTStockTableDelegate>
@property(nonatomic,readwrite,strong)ADSTStockTableView* stockView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stockView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:self.stockView];
}

#pragma mark - Stock DataSource


- (NSUInteger)countForStockView:(ADSTStockTableView*)stockView{
     return 30;
}

- (UIView*)cellFixedViewForStockView:(ADSTStockTableView*)stockView rowPath:(NSUInteger)row{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
          label.textColor = [UIColor grayColor];
          label.backgroundColor = [UIColor colorWithRed:223.0f/255.0 green:223.0f/255.0 blue:223.0f/255.0 alpha:1.0];
          label.textAlignment = NSTextAlignmentCenter;
          return label;
    
}


- (UIView*)cellLeftContentForStockView:(ADSTStockTableView*)stockView rowPath:(NSUInteger)row{
         UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 30)];
        for (int i = 9; i >= 0; i--) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((9-i) * 100, 0, 100, 30)];
            label.textAlignment = NSTextAlignmentCenter;
            [bg addSubview:label];
        }
        return bg;
}


- (UIView*)cellRightContentForStockView:(ADSTStockTableView*)stockView rowPath:(NSUInteger)row{
        UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 30)];
        for (int i = 0; i < 10; i++) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(i * 100, 0, 100, 30)];
            label.textAlignment = NSTextAlignmentCenter;
            [bg addSubview:label];
        }
        return bg;
}


#pragma mark -  Delegate

- (UIView*)headFixedView:(ADSTStockTableView*)stockView{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 40)];
     label.text = @"表头";
     label.backgroundColor = [UIColor whiteColor];
     label.textColor = [UIColor grayColor];
     label.textAlignment = NSTextAlignmentCenter;
     return label;
}

- (UIView*)headLeftView:(ADSTStockTableView*)stockView{
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 40)];
    for (int i = 9; i >= 0; i--) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((9-i) * 100, 0, 100, 40)];
        label.text = [NSString stringWithFormat:@"表头:%d",i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        [bg addSubview:label];
    }
    return bg;
}

- (UIView*)headRightView:(ADSTStockTableView*)stockView{
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 40)];
    for (int i = 0; i < 10; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(i * 100, 0, 100, 40)];
        label.text = [NSString stringWithFormat:@"表头:%d",i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        [bg addSubview:label];
    }
    return bg;
}

- (CGFloat)heightForHeadView:(ADSTStockTableView*)stockView{
     return 40.0f;
}


- (CGFloat)heightForCell:(ADSTStockTableView*)stockView indexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}


- (void)updateCellStockView:(ADSTStockTableView*)stockView fixedView:(UIView*)fixedView leftContentView:(UIView*)leftView rightContentView:(UIView*)rightView rowPath:(NSUInteger)row{
    
    UILabel* label =(UILabel*) fixedView;
    label.text = [NSString stringWithFormat:@"标题:%ld",row];
    
    for (UILabel* label in leftView.subviews ) {
        label.text = [NSString stringWithFormat:@"左内容:%ld",row];
    }
    
    for (UILabel* label in rightView.subviews ) {
           label.text = [NSString stringWithFormat:@"右内容:%ld",row];
    }

}

- (void)didSelect:(ADSTStockTableView*)stockView rowPath:(NSUInteger)row{
    
}


#pragma mark - Get

- (ADSTStockTableView*)stockView{
    if(_stockView != nil){
        return _stockView;
    }
    _stockView = [ADSTStockTableView new];
    _stockView.dataSource = self;
    _stockView.delegate = self;
    return _stockView;
}


@end
