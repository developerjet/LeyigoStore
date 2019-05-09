//
//  FSLogRegistConfig.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSLogRegistConfig.h"

@implementation FSLogRegistConfig

- (instancetype)initTitle:(NSString *)t placeholder:(NSString *)p secureTextEntry:(BOOL)s {
    
    if (self = [super init]) {
        self.title = t;
        self.placeholder = p;
        self.secureTextEntry = s;
    }
    return self;
}

+ (instancetype)initTitle:(NSString *)t placeholder:(NSString *)p secureTextEntry:(BOOL)s {
    
    FSLogRegistConfig *config = [[FSLogRegistConfig alloc] init];
    config.title = t;
    config.placeholder = p;
    config.secureTextEntry = s;
    return config;
}


- (instancetype)initTitle:(NSString *)title text:(NSString *)text placeholder:(NSString *)placeholder  secureTextEntry:(BOOL)secureTextEntry {
    
    if (self = [super init]) {
        self.text = text;
        self.title = title;
        self.placeholder = placeholder;
        self.secureTextEntry = secureTextEntry;
    }
    return self;
}

+ (instancetype)initTitle:(NSString *)title text:(NSString *)text placeholder:(NSString *)placeholder  secureTextEntry:(BOOL)secureTextEntry {
    
    FSLogRegistConfig *config = [[FSLogRegistConfig alloc] init];
    config.text = text;
    config.title = title;
    config.placeholder = placeholder;
    config.secureTextEntry = secureTextEntry;
    return config;
}

- (instancetype)initTitle:(NSString *)title placeholder:(NSString *)placeholder {
    
    if (self = [super init]) {
        self.title = title;
        self.placeholder = placeholder;
    }
    return self;
}

+ (instancetype)initTitle:(NSString *)title placeholder:(NSString *)placeholder {
    
    FSLogRegistConfig *config = [[FSLogRegistConfig alloc] init];
    config.title = title;
    config.placeholder = placeholder;
    return config;
}


- (instancetype)initTitle:(NSString *)title subtitle:(NSString *)subtitle placeholder:(NSString *)placeholder {

    if (self = [super init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.placeholder = placeholder;
    }
    return self;
}


+ (instancetype)initTitle:(NSString *)title subtitle:(NSString *)subtitle placeholder:(NSString *)placeholder {
    
    FSLogRegistConfig *config = [[FSLogRegistConfig alloc] init];
    config.title = title;
    config.subtitle = subtitle;
    config.placeholder = placeholder;
    return config;
}

@end
