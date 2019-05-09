//
//  FSShopCart.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSShopCartList.h"

@implementation FSShopCartList

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField": @"id",
             @"proId": @"pro_id",
             @"pricePifa": @"price_pifa",
             @"guigeName": @"guige_name"};
}

@end
