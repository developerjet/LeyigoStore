//
//  FSBaseModel.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/25.
//  Copyright © 2018 FTS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSBaseModel : NSObject

@property (nonatomic, copy) NSString * tel;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * uname;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, assign) BOOL isShow;

+ (instancetype)initImage:(NSString *)image title:(NSString *)title;
- (instancetype)initImage:(NSString *)image title:(NSString *)title;

+ (instancetype)initTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (instancetype)initTitle:(NSString *)title subtitle:(NSString *)subtitle;

+ (instancetype)initImage:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle;
- (instancetype)initImage:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
