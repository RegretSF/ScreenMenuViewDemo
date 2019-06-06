//
//  FSScreenMenuView.h
//  ScreenMenuViewDemo
//
//  Created by tq001 on 2019/6/6.
//  Copyright © 2019 Fat brther. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FSScreenMenuView;
@protocol FSScreenMenuViewDelegate <NSObject>

/**传出点击选中标题的索引*/
- (void)screenMenuView:(FSScreenMenuView *)screenMenuView didSelectTitleIndex:(NSInteger)index;
/**传出点击选中内容文本相应的行数*/
- (void)screenMenuView:(FSScreenMenuView *)screenMenuView didSelectCententCellRow:(NSInteger)row;

@end

/**筛选菜单视图*/
@interface FSScreenMenuView : UIView
#pragma mark 属性
@property(nonatomic,weak) id <FSScreenMenuViewDelegate>delegate;
/**标题数组*/
@property(nonatomic,strong) NSArray *titles;
/**排序内容数组*/
@property(nonatomic,strong) NSArray *contentTexts;
/**筛选标题未选中的颜色*/
@property(nonatomic,strong) UIColor *titleColorNormal;
/**筛选标题选中的颜色*/
@property(nonatomic,strong) UIColor *titleColorSelect;
/**筛选标题未选中的图标*/
@property(nonatomic,strong) UIImage *titleIconNormal;
/**筛选标题选中的图标*/
@property(nonatomic,strong) UIImage *titleIconSelect;
/**cell里标题的颜色*/
@property(nonatomic,strong) UIColor *cententTitleColor;
@end

NS_ASSUME_NONNULL_END
