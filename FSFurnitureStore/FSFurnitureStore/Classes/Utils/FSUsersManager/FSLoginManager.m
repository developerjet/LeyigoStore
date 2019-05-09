//
//  FSUsersManager.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSLoginManager.h"

@implementation FSLoginManager

+ (instancetype)manager {
    static FSLoginManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[FSLoginManager alloc] init];
    });
    return _shared;
}

- (NSString *)token {
    if ([UD objectForKey:UD_USER_TOKEN]) {
        return [UD objectForKey:UD_USER_TOKEN];
    }else {
        return nil;
    }
}

- (NSString *)account {
    if ([UD objectForKey:UD_USER_ACCOUNT]) {
        return [UD objectForKey:UD_USER_ACCOUNT];
    }else {
        return @"";
    }
}

- (NSString *)password {
    if ([UD objectForKey:UD_USER_PASSWORD]) {
        return [UD objectForKey:UD_USER_PASSWORD];
    }else {
        return @"";
    }
}

@end
