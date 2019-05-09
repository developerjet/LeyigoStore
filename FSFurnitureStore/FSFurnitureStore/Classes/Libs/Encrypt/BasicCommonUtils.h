//
//  BasicCommonUtils.h
//  OnlyBrother_ Seller
//
//  Created by 任健东 on 16/9/14.
//  Copyright © 2016年 任健东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicCommonUtils : NSObject

#pragma mark - base64
+(NSString *)encodeBase64String:(NSString *)input;
+(NSString *)decodeBase64String:(NSString *)input;
+(NSString *)encodeBase64Data:(NSData *)data;
+(NSString *)decodeBase64Data:(NSData *)data;
@end
