//
//  CacheManager.h
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/22.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FSCacheManager : NSObject

/**
 *  管理单利
 */
+ (instancetype)shared;

/**
 * 图片所有的收藏数据
 */
@property (nonatomic, strong) NSMutableArray *caches;

/**
 主题颜色配置表
 */
@property (nonatomic, strong) NSArray <NSString *>*themes;

/**
 主题颜色
 */
@property (nonatomic, strong) UIColor *themeColor;

/**
 当前图片缓存大小
 */
@property (nonatomic, copy) NSString *cacheSize;

/**
 清除当前图片缓存
 */
- (void)clearCache;

/**
 获取当前时间
 
 @param formatter 时间格式设置
 */
- (NSString *)dateFormatter:(NSString *)formatter;


@end
