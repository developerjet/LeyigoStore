//
//  FSLogRegistConfig.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSLogRegistConfig : NSObject

- (instancetype)initTitle:(NSString *)t
              placeholder:(NSString *)p
          secureTextEntry:(BOOL)s;

+ (instancetype)initTitle:(NSString *)t
              placeholder:(NSString *)p
          secureTextEntry:(BOOL)s;



- (instancetype)initTitle:(NSString *)title
              placeholder:(NSString *)placeholder;

+ (instancetype)initTitle:(NSString *)title
              placeholder:(NSString *)placeholder;



- (instancetype)initTitle:(NSString *)title
                 subtitle:(NSString *)subtitle
              placeholder:(NSString *)placeholder;

+ (instancetype)initTitle:(NSString *)title
                 subtitle:(NSString *)subtitle
              placeholder:(NSString *)placeholder;


- (instancetype)initTitle:(NSString *)title
                     text:(NSString *)text
              placeholder:(NSString *)placeholder
          secureTextEntry:(BOOL)secureTextEntry;

+ (instancetype)initTitle:(NSString *)title
                     text:(NSString *)text
              placeholder:(NSString *)placeholder
          secureTextEntry:(BOOL)secureTextEntry;

@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, copy) NSString * tel;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * uname;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, assign) NSInteger returns;
@property (nonatomic, copy) NSString * appkey;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * sheng;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * quyu;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, assign) BOOL secureTextEntry;

@end

NS_ASSUME_NONNULL_END
