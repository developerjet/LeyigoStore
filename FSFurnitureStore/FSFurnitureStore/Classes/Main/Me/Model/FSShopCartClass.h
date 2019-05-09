//
//  FSShopCartClass.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSShopCartList.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSShopCartClass : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * post;
@property (nonatomic, strong) NSString * post_max;
@property (nonatomic, strong) NSDictionary * partner;
@property (nonatomic, strong) NSArray * list;

@end

NS_ASSUME_NONNULL_END
