//
//	Json.h
//
//	Create by TJ on 25/11/2018
//	Copyright © 2018. All rights reserved.
//

//	

#import <UIKit/UIKit.h>
#import "FSHomeSubClass.h"

@interface FSHomeJsonClass : NSObject

@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSArray * subClass;
@property (nonatomic, strong) FSHomeSubClass *sub;

@end
