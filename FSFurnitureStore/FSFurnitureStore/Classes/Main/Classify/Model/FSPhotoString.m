//
//	PhotoString.m
//
//	Create by TJ on 28/11/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FSPhotoString.h"

NSString *const kPhotoStringImg = @"img";
NSString *const kPhotoStringImgBig = @"img_big";

@interface FSPhotoString ()
@end
@implementation FSPhotoString




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kPhotoStringImg] isKindOfClass:[NSNull class]]){
		self.img = dictionary[kPhotoStringImg];
	}	
	if(![dictionary[kPhotoStringImgBig] isKindOfClass:[NSNull class]]){
		self.imgBig = dictionary[kPhotoStringImgBig];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.img != nil){
		dictionary[kPhotoStringImg] = self.img;
	}
	if(self.imgBig != nil){
		dictionary[kPhotoStringImgBig] = self.imgBig;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.img != nil){
		[aCoder encodeObject:self.img forKey:kPhotoStringImg];
	}
	if(self.imgBig != nil){
		[aCoder encodeObject:self.imgBig forKey:kPhotoStringImgBig];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.img = [aDecoder decodeObjectForKey:kPhotoStringImg];
	self.imgBig = [aDecoder decodeObjectForKey:kPhotoStringImgBig];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	FSPhotoString *copy = [FSPhotoString new];

	copy.img = [self.img copy];
	copy.imgBig = [self.imgBig copy];

	return copy;
}
@end
