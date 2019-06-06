//
//  ViewController.m
//  ScreenMenuViewDemo
//
//  Created by tq001 on 2019/6/6.
//  Copyright © 2019 Fat brther. All rights reserved.
//

#import "ViewController.h"
#import "FSScreenMenuView.h"

#define kStatusBarH [UIApplication sharedApplication].statusBarFrame.size.height  //状态栏的高度

@interface ViewController ()
/**筛选菜单视图*/
@property (nonatomic,strong) FSScreenMenuView *menuView;
@end

@implementation ViewController{
    CGFloat kNavigationBarH;
}
#pragma mark 懒加载
- (FSScreenMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[FSScreenMenuView alloc] init];
        NSArray *titles = [NSArray arrayWithObjects:@"全部", @"价格", @"销量", @"人气", nil];
        _menuView.titles = titles;
    }
    return _menuView;
}

#pragma mark 系统回调函数
- (void)viewDidLoad {
    [super viewDidLoad];
    //0、获取导航栏的高度
    kNavigationBarH = self.navigationController.navigationBar.frame.size.height;
    
    //1、添加子视图
    [self addSubviews];
}

#pragma mark 设置UI界面
- (void)addSubviews {
    //添加筛选菜单视图
    self.menuView.frame = CGRectMake(0, kNavigationBarH + kStatusBarH, [UIScreen mainScreen].bounds.size.width, 45);
    [self.view addSubview:self.menuView];
}

@end
