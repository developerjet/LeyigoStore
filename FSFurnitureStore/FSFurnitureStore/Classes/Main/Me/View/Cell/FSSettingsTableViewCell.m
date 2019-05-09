//
//  FSSettingsTableViewCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSSettingsTableViewCell.h"

@implementation FSSettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(FSBaseModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
