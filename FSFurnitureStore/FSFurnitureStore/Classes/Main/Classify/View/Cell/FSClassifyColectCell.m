//
//  FSClassifyColectCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSClassifyColectCell.h"

@interface FSClassifyColectCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FSClassifyColectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(FSClassifyRoot *)model {

    _model = model;
    
    self.nameLabel.text = model.name;
    [self.imageView setImage:model.img placeholder:@"img_empty"];
}

@end
