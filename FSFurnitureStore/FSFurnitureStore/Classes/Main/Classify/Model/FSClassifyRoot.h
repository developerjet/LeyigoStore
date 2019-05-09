//
//	RootClass.h
//
//	Create by TJ on 27/11/2018
//	Copyright © 2018. All rights reserved.
//

//	

#import <UIKit/UIKit.h>

@interface FSClassifyRoot : NSObject
@property (nonatomic, strong) NSObject * color;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * price_yj;
@property (nonatomic, strong) NSArray * subclass;

@property (nonatomic, assign) NSInteger gid;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger renqi;
@property (nonatomic, assign) NSInteger shiyong;
@end
