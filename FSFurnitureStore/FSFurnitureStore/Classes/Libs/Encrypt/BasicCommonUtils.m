//
//  BasicCommonUtils.m
//  OnlyBrother_ Seller
//
//  Created by 任健东 on 16/9/14.
//  Copyright © 2016年 任健东. All rights reserved.
//

#import "BasicCommonUtils.h"


#import "GTMBase64.h"
@implementation BasicCommonUtils

#pragma mark - Base64
+(NSString *)encodeBase64String:(NSString *)input{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
+(NSString *)decodeBase64String:(NSString *)input{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
+(NSString *)encodeBase64Data:(NSData *)data{
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
+(NSString *)decodeBase64Data:(NSData *)data{
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


@end
