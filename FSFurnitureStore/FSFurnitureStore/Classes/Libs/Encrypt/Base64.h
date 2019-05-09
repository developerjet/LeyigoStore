//
//  Base64.h
//  Encrypt
//
//  Created by 马康旭 on 16/10/31.
//  Copyright © 2016年 马康旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

+(NSString *)encode:(NSData *)data;
+(NSData *)decode:(NSString *)dataString;

@end
