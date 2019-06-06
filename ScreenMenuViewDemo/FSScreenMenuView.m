//
//  FSScreenMenuView.m
//  ScreenMenuViewDemo
//
//  Created by tq001 on 2019/6/6.
//  Copyright © 2019 Fat brther. All rights reserved.
//

#import "FSScreenMenuView.h"
#import "FSTitleButton.h"

@interface FSScreenMenuView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *btns;
@end

@implementation FSScreenMenuView{
    /**按钮的宽度*/
    CGFloat cellW;
    /**记录点击当前的按钮*/
    NSInteger currentIndex;
}
//***********************************cellID***************************************//
static NSString * const collectionViewCellID = @"collectionViewCellID";
//********************************************************************************//
#pragma mark set方法
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
        
        //1、添加子视图
        [self addSubviews];
    }
    
    return self;
}

#pragma mark 设置UI界面
/*
 *添加子视图
 */
- (void)addSubviews {
    //添加collectionView
    [self addSubview:self.collectionView];
    
}

//调用父类布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    
    
}

#pragma mark 监听事件
- (void)clickButton:(UIButton *)button {
    //1.获取当前label
    UIButton *currentBtn = button;
    
    //2.获取之前的label
    UIButton *oldBtn = self.btns[currentIndex];
    
    //3.切换按钮的状态
    if (currentBtn.tag == oldBtn.tag) {
        
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
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:195.0/255.0 green:154.0/255.0 blue:121.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"xia_search"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateSelected];
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
    
    return CGSizeMake(cellW, 44);
}
@end
