//
//  FSScreenMenuView.m
//  ScreenMenuViewDemo
//
//  Created by tq001 on 2019/6/6.
//  Copyright © 2019 Fat brther. All rights reserved.
//

#import "FSScreenMenuView.h"

@interface FSScreenMenuView ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *btns;
@property(nonatomic,assign) BOOL isClickDismiss;
@end

@implementation FSScreenMenuView{
    /**按钮的宽度*/
    CGFloat cellW;
    /**记录点击当前的按钮*/
    NSInteger currentIndex;
}
//***********************************cellID***************************************//
static NSString * const collectionViewCellID = @"collectionViewCellID";
static NSString * const tableViewCellID = @"tableViewCellID";
//********************************************************************************//
#pragma mark set方法
- (void)setContentTexts:(NSMutableArray *)contentTexts {
    _contentTexts = contentTexts;
    
    //刷新
    [self.tableView reloadData];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    //设置cell的宽度
    cellW = [UIScreen mainScreen].bounds.size.width / titles.count;
    
    //刷新
    [self.collectionView reloadData];
}

#pragma mark 懒加载
- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.hidden = YES;
    }
    
    return _tableView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.2;
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        _maskView.hidden = YES;
        [_maskView addGestureRecognizer:tapGes];
    }
    return _maskView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //1、1.创建layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //2、创建collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //设置collectionView的一些属性
        _collectionView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        //注册cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        
    }
    
    return _collectionView;
}

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //0、初始化一些值
        currentIndex = 0;
        self.isClickDismiss = NO;
        self.titleColorNormal = [UIColor blackColor];
        self.titleColorSelect = [UIColor orangeColor];
        
        //1、添加子视图
        [self addSubviews];
    }
    
    return self;
}

//重写此方法解决子视图超出父视图点击不响应的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView * subView in self.subviews) {
            // 将坐标系转化为自己的坐标系
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

#pragma mark 设置UI界面
/*
 *添加子视图
 */
- (void)addSubviews {
    //1、添加collectionView
    [self addSubview:self.collectionView];
    
    //2、添加遮罩
    [self addSubview:self.maskView];
    
    //3、添加tableView
    [self addSubview:self.tableView];
    
}

//调用父类布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
    CGFloat maskH = [UIScreen mainScreen].bounds.size.height - (self.bounds.origin.y + self.bounds.size.height);
    self.maskView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, maskH);

}

#pragma mark 监听事件
- (void)clickButton:(UIButton *)button {
    //0.显示遮罩、tableView
    self.maskView.hidden = NO;
    self.tableView.hidden = NO;
    
    //1.获取当前label
    UIButton *currentBtn = button;
    
    //2.获取之前的label
    UIButton *oldBtn = self.btns[currentIndex];
    
    //3.切换按钮的状态
    if (currentBtn.tag == oldBtn.tag) {

        if (self.isClickDismiss == YES) {
            currentBtn.selected = YES;
            self.isClickDismiss = NO;
        }
        
        if (currentBtn.tag != 0) {  //如果不是第一个button
            return;
        }else {
            currentBtn.selected = YES;
        }
        
    }else {
        
        currentBtn.selected = YES;
        oldBtn.selected = NO;
        
    }
    
    //4.保存最新Label的下标值
    currentIndex = currentBtn.tag;
    
    //5.设置tableView的高度
    NSArray *textArr = self.contentTexts[currentIndex];
    CGFloat tableViewH = self.tableView.rowHeight * textArr.count;
    self.tableView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, tableViewH);
    [self.tableView reloadData];
    
    //6.通知代理
    if ([self.delegate respondsToSelector:@selector(screenMenuView:didSelectTitleIndex:)]) {
        [self.delegate screenMenuView:self didSelectTitleIndex:currentIndex];
    }
}

/**
 *消隐视图
 */
- (void)dismiss {
    //1、隐藏遮罩、tableView
    self.maskView.hidden = YES;
    self.tableView.hidden = YES;
    
    //2.获取当前label，取消button的选择状态
    UIButton *currentBtn = self.btns[currentIndex];
    currentBtn.selected = NO;
    
    //记录是点击dismiss
    self.isClickDismiss = YES;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *textArr = self.contentTexts[currentIndex];
    return textArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *textArr = self.contentTexts[currentIndex];
    cell.textLabel.text = textArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //通知代理
    if ([self.delegate respondsToSelector:@selector(screenMenuView:didSelectCententCellRow:)]) {
        [self.delegate screenMenuView:self didSelectCententCellRow:indexPath.row];
    }
    
    [self dismiss];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    
    //给cell设置内容
    //防止循环利用cell时多次添加 view ，所以在添加childVC.view之前先把之前缓存的视图给移除
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //创建UIButton
    UIButton *btn = [[UIButton alloc] initWithFrame:cell.contentView.bounds];
    //设置UIButton的一些属性
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = indexPath.item;
    [btn setTitle:self.titles[indexPath.item] forState:UIControlStateNormal];
    [btn setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
    [btn setTitleColor:self.titleColorSelect forState:UIControlStateSelected];
    [btn setImage:self.titleIconNormal forState:UIControlStateNormal];
    [btn setImage:self.titleIconSelect forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    //互换title和imageView的位置
    btn.titleLabel.backgroundColor = btn.backgroundColor;   //设置一下它的背景色和button一致(只是为了提前使用一次):
    btn.imageView.backgroundColor = btn.backgroundColor;    //设置一下它的背景色和button一致(只是为了提前使用一次):
    CGSize titleSize = btn.titleLabel.bounds.size;
    CGSize imageSize = btn.imageView.bounds.size;
    CGFloat interval = 1.0;
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    btn.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
    //添加到contentView
    [cell.contentView addSubview:btn];
    [self.btns addObject:btn];
    
    if (indexPath.item != 0) {
        //添加垂直分割线
        UIView *lineVer = [[UIView alloc] init];
        CGFloat lineY = 10;
        lineVer.frame = CGRectMake(0, lineY, 1, cell.contentView.frame.size.height - lineY * 2);
        lineVer.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineVer];
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(cellW, self.collectionView.frame.size.height - 2);
}
@end
