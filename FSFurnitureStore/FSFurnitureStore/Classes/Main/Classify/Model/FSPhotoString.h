//
//	PhotoString.h
//
//	Create by TJ on 28/11/2018
//	Copyright © 2018. All rights reserved.
//

//	

#import <UIKit/UIKit.h>

@interface FSPhotoString : NSObject
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * imgBig;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
