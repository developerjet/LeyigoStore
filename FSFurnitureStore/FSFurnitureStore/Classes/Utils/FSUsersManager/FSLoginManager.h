//
//  FSUsersManager.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FSLogRegistConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSLoginManager : NSObject

/**
 用户登录&注册信息管理
 */
+ (instancetype)manager;

/**
 用户token
 */
@property (nonatomic, strong) NSString *token;

/**
 用户基本信息
 */
@property (nonatomic, strong) FSLogRegistConfig *info;


/**
 用户名
 */
@property (nonatomic, strong) NSString *account;

/**
 用户密码
 */
@property (nonatomic, strong) NSString *password;

@end


NS_ASSUME_NONNULL_END
