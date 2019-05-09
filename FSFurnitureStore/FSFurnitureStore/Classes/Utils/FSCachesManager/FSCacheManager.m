//
//  CacheManager.m
//  FoodCourt
//
//  Created by Original_TJ on 2018/3/22.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FSCacheManager.h"
#import <SDWebImageManager.h>


#define kCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"caches.plist"]

@implementation FSCacheManager
{
    NSMutableArray *_caches;
}

#pragma mark - Private Methods

+ (instancetype)shared {
    static FSCacheManager *_s = nil;
    static dispatch_once_t o;
    dispatch_once(&o, ^{
        _s = [[FSCacheManager alloc] init];
    });
    return _s;
}

- (NSMutableArray *)caches {
    
    if (_caches == nil) {
        
        _caches = [NSKeyedUnarchiver unarchiveObjectWithFile:kCachePath];
        
        if (_caches == nil) {
            
            _caches = [NSMutableArray array];
        }
    }
    return _caches;
}


#pragma mark - 图片缓存管理

- (NSString *)cacheSize {
    NSInteger caches = [[SDImageCache sharedImageCache] getSize];
    if (caches) {
        if (caches>1024.0*1024.0) {
            return [NSString stringWithFormat:@"%.2fMB", caches/1024.0/1024.0];
        }else if (caches>1024.0) {
            return [NSString stringWithFormat:@"%.2fKB", caches/1024.0];
        }else if (caches>0) {
            return [NSString stringWithFormat:@"%.2ldB", caches];
        }
    }
    return @"0KB";
}

// yyyy-MM-dd HH:mm:ss
- (NSString *)dateFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatter];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

- (void)clearCache {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

@end
