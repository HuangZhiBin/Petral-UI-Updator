//
//  ZYSuspensionManager.h
//  suspendButton
//
//  Created by wanglei on 17/1/9.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYSuspensionManager : NSObject
+ (instancetype)shared;

/**
 *  根据key值取window
 *
 *  @param key key
 *
 *  @return window
 */
+ (UIWindow *)windowForKey:(NSString *)key;

/**
 *  持有一个window并设置key值
 *
 *  @param window window
 *  @param key    key值
 */
+ (void)saveWindow:(UIWindow *)window forKey:(NSString *)key;

/**
 *  销毁一个window
 *
 *  @param key       根据key值
 */
+ (void)destroyWindowForKey:(NSString *)key;

/**
 *  销毁当前所有window
 */
+ (void)destroyAllWindow;
@end
