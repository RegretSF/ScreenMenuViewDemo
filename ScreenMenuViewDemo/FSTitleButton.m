//
//  FSTitleButton.m
//  ScreenMenuViewDemo
//
//  Created by tq001 on 2019/6/6.
//  Copyright © 2019 Fat brther. All rights reserved.
//

#import "FSTitleButton.h"

@implementation FSTitleButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    //文字左移
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, 0.0, imageSize.width);
    //图片右移
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width, 0.0, -titleSize.width);
    
}

@end
