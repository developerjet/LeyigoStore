//
//  FSStoreProductCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreProductCell.h"

@interface FSStoreProductCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FSStoreProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(FSStoreSubclas *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    [self.imageView setImage:model.photoX placeholder:@"img_empty"];
}

@end
