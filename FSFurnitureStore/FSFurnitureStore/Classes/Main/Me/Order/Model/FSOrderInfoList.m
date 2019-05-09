//
//  FSOrderInfoList.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/3.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSOrderInfoList.h"

@implementation FSOrderInfoList

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField": @"id",
             @"proId": @"pro_id",
             @"pricePifa": @"price_pifa",
             @"guigeName": @"guige_name"};
}

@end
