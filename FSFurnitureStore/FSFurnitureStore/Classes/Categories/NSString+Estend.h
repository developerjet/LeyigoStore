//
//  NSString+Estend.h
//  HotChat
//
//  Created by wangjun on 15/8/21.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Estend)
- (NSString *)HMACWithSecret:(NSString *)secret;
+ (NSString *)getDeviceName;
- (NSString *)fileIdFromUrl;
/// 手机号码格式化 例如:136 5422 5352
+ (NSString *)phoneNumFormat:(NSString *)phoneString;
/// 去掉手机号格式化之后的空格
- (NSString *)trimAll;
/// MD5处理
- (NSString *)md5;
- (NSString *)sha1;	
+ (NSString *)phone:(NSString *)phone num:(NSString *)num;
/// 格式化语音时长  return: mm'ss"
+ (NSString *)stringFormatWithVoiceTime:(NSInteger)time;
/// 格式化语音时长  return: mm:ss
+ (NSString *)stringFormatWithVoiceTime1:(NSInteger)time;
/// 截取语音的filedId
+ (NSString *)stringWithAudioUrl:(NSString *)url;
/// 传入的时间搓与当前时间比较 return: hh:mm/昨天hh:mm/MM-dd hh:mm/yyyy-MM-dd hh:mm
+ (NSString *)dateStringWithTime:(NSString *)time;
/// 格式化距离
+ (NSString *)stringWithDistance:(NSInteger)distance;
+ (NSString *)fileIDPlistPath;
+ (NSString *)nowDate;
+ (NSDictionary *)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding;
/// 获取当前时间戳格式XXXX-XX-XX
+ (NSString *)getNowTimeStr;
/// 正则表达式取链接URL里的汉字
+ (NSString *)textSelectFromHerfString:(NSString *)string;
/// 处理国家码
+ (NSString *)getAreaCodeWithString:(NSString *)areaCode;
/// 手机号码正则处理
+ (BOOL)isValidateHomePhoneNum:(NSString *)phoneNum;
/// 中文正则
- (BOOL)isValidateChinese;

/// 去除空格符
+ (NSString *)deteleTheBlankWithString:(NSString *)str;

/// 账号设置正则处理
+ (BOOL)isValidAccount:(NSString *)account;
/// 密码设置正则处理
+ (BOOL)isValidPassword:(NSString *)passWord;

///身份证号正则处理
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

///时间戳处理
+ (NSString *)compareCurrentTime:(NSString *)str;
+ (NSString *)getTime:(NSString *)time;

///请求完整Url打印处理
+ (NSString *)getUrlWithBaseUrl:(NSString *)baseUrl parameters:(NSDictionary *)parameters;


@end
