//
//  FSBaseModel.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/25.
//  Copyright © 2018 FTS. All rights reserved.
//

#import "FSBaseModel.h"

@implementation FSBaseModel

+ (instancetype)initImage:(NSString *)image title:(NSString *)title {

    FSBaseModel *model = [[FSBaseModel alloc] init];
    model.image = image;
    model.title = title;
    return model;
}

- (instancetype)initImage:(NSString *)image title:(NSString *)title {
    
    if (self = [super init]) {
        self.image = image;
        self.title = title;
    }
    return self;
}


+ (instancetype)initTitle:(NSString *)title subtitle:(NSString *)subtitle {
    
    FSBaseModel *model = [[FSBaseModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    return model;
}

- (instancetype)initTitle:(NSString *)title subtitle:(NSString *)subtitle {
    
    if (self = [super init]) {
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

+ (instancetype)initImage:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    
    FSBaseModel *model = [[FSBaseModel alloc] init];
    model.image = image;
    model.title = title;
    model.subtitle = subtitle;
    return model;
}

- (instancetype)initImage:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle {

    if (self = [super init]) {
        self.image = image;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}


@end
