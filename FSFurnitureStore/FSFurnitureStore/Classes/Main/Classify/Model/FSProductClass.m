//
//	RootClass.m
//
//	Create by TJ on 28/11/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FSProductClass.h"

@implementation FSProductClass

+ (void)load {
    
    //驼峰转下划线
    [self mj_setupReplacedKeyFromPropertyName121:^id(NSString *propertyName) {
        
        return [propertyName mj_underlineFromCamel];
    }];
    
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return  @{@"idField" :@"id"};
    }];
}

@end
