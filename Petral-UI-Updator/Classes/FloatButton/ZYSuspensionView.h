//
//  ZYSuspensionView.h
//  suspendButton
//
//  Created by wanglei on 17/1/9.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYSuspensionManager.h"

@class ZYSuspensionView;

@protocol ZYSuspensionViewDelegate <NSObject>
/** 点击悬浮球的回调 */
- (void)suspensionViewClick:(ZYSuspensionView *)suspensionView;
@end

typedef NS_ENUM(NSUInteger, ZYSuspensionViewLeanType) {
    /** 仅可停留在左、右 */
    ZYSuspensionViewLeanTypeHorizontal,
    /** 可停留在上、下、左、右 */
    ZYSuspensionViewLeanTypeEachSide
};


@interface ZYSuspensionView : UIButton

/** 代理 */
@property (nonatomic, weak) id<ZYSuspensionViewDelegate> delegate;
/** 倚靠类型 default is ZYSuspensionViewLeanTypeHorizontal */
@property (nonatomic, assign) ZYSuspensionViewLeanType leanType;


- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color delegate:(id<ZYSuspensionViewDelegate>)delegate;

/**
 *  显示
 */
- (void)show;

@end
