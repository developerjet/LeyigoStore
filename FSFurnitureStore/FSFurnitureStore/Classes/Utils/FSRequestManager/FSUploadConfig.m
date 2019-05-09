//
//  FSUploadConfig.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/16.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSUploadConfig.h"

#define ENCODE(x) [x dataUsingEncoding:NSUTF8StringEncoding]

@implementation FSUploadConfig

static FSUploadConfig *_uploadConfig = nil;

#pragma mark - Public

+ (instancetype)config {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uploadConfig = [[FSUploadConfig alloc] init];
    });
    return _uploadConfig;
}


#pragma mark - Upload Methods

- (void)uploadImageWithData:(NSData *)imageData success:(void (^)(id _Nonnull))responseBlock failure:(void (^)(NSError * _Nonnull))failureBlock {
    //图片上传服务器URL
    NSString *uploadUrl = kUpload_Photo;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 请求返回的格式为json
    //_sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    //设置请求超时
    manager.requestSerializer.timeoutInterval = 6;
    //向AFN添加一些隐私权策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    //接收参数类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[FSLoginManager manager].token forKey:@"token"];
    //[parameters setObject:imageData forKey:@"photo"];
    [parameters setObject:@"3406" forKey:@"appkey"];

    [manager POST:uploadUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 图片上传格式处理
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData name:@"photo" fileName:fileName mimeType:@"image/jpeg"];

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        !responseBlock?:responseBlock(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        !failureBlock?:failureBlock(error);
    }];
}

- (NSString *)JSONStringWithObject:(id)object {
    
    NSData *contentData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    NSString *contentString = [[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding];
    return contentString;
}

- (NSURLSessionUploadTask *)uploadImageWithData:(NSData *)imageData progress:(void (^)(double))progressBlock success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSString *uploadURL = kUpload_Photo;
    
    NSDictionary * para = @{@"appkey": @"3406",
                            @"token": [FSLoginManager manager].token};
    //请求体
    NSMutableData * dataM = [NSMutableData data];

    //1>拼接开始标志，自定义
    NSString * mark=@"mark";

    /* 普通参数*/
    [para enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        NSString *boundry = [NSString stringWithFormat:@"--%@\r\n",mark];
        [dataM appendData:ENCODE(boundry)];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",key];

        [dataM appendData:ENCODE(disposition)];
        [dataM appendData:ENCODE(@"\r\n")];
        [dataM appendData:ENCODE(obj)];
        [dataM appendData:ENCODE(@"\r\n")];

    }];

    /* 文件参数*/
    if(imageData && imageData.length>0)
    {
        NSString *boundry = [NSString stringWithFormat:@"--%@\r\n",mark];

        [dataM appendData:ENCODE(boundry)];

        NSString *disposition=[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n",@"image",@"image/jpeg"];

        [dataM appendData:ENCODE(disposition)];
        [dataM appendData:imageData];
        [dataM appendData:ENCODE(@"\r\n")];
    }

    NSString *strBottom = [NSString stringWithFormat:@"--%@--\r\n",mark];
    [dataM appendData:ENCODE(strBottom)];

    //请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uploadURL]];

    [request setHTTPMethod:@"POST"];

    NSString * format=[NSString stringWithFormat:@"multipart/form-data; boundary=%@",mark];

    [request setValue:format forHTTPHeaderField:@"Content-Type"];


    NSURLSessionUploadTask * task  =  [[AFHTTPSessionManager manager] uploadTaskWithRequest:request fromData:dataM progress:^(NSProgress * progress){

        double totalLength = dataM.length;
        double percent = progress.completedUnitCount / totalLength;

        if (percent < 0){
            percent = 0;
        }

        if (percent > 1){
            percent = 1;
        }

        !progressBlock?:progressBlock(percent);

    }completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error != nil){

            failure(error);

        }else{

            success(responseObject);
        }
    }];

    [task resume];

    return task;
}

@end
