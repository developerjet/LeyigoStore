//
//  FSHttpResult.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSHttpResult : NSObject

@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * idField;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, assign) NSInteger returns;

@end

NS_ASSUME_NONNULL_END
