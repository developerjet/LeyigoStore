//
//  FSShopCart.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSShopCartList : NSObject

@property (nonatomic, strong) NSString * buff;
@property (nonatomic, strong) NSString * del;
@property (nonatomic, strong) NSString * guigeName;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSString * pricePifa;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * proId;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
