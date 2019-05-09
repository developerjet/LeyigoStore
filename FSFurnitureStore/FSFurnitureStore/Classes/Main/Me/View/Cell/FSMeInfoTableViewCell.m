//
//  FSMeInfoTableCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSMeInfoTableViewCell.h"

@interface FSMeInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *curImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FSMeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(FSBaseModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.curImgView.image = [UIImage imageNamed:model.image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
