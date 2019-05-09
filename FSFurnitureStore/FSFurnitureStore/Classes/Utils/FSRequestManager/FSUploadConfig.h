//
//  FSUploadConfig.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/16.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface FSUploadConfig : NSObject

/**
 上传管理单利
 */
+ (instancetype)config;


/**
 文件流格式上传

 @param imageData 需要上传图片数据
 @param responseBlock 上传成功回调
 @param failureBlock 上传失败回调
 */
- (void)uploadImageWithData:(NSData *)imageData
                    success:(void(^)(id response))responseBlock
                    failure:(void(^)(NSError *error))failureBlock;

/**
 表单格式上传

 @param imageData 需要上传图片数据
 @param progressBlock 上传进度
 @param success 上传成功回调
 @param failure 上传失败回调
 */
- (NSURLSessionUploadTask *)uploadImageWithData:(NSData *)imageData
                                       progress:(void(^)(double progress))progressBlock
                                        success:(void(^)(id response))success
                                        failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
