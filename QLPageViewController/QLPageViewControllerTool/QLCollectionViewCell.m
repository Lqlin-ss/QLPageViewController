//
//  QLCollectionViewCell.m
//  QLPageViewController
//
//  Created by 梁啟林 on 2018/8/7.
//  Copyright © 2018年 liangqilin. All rights reserved.
//
//

#import "QLCollectionViewCell.h"

@implementation QLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    _textLabel = [[UILabel alloc] init];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

@end
