//
//  FSStoreContactCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/3.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreContactCell.h"

@interface FSStoreContactCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightView;

@end

@implementation FSStoreContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(FSBaseModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.rightView.image = [UIImage imageNamed:model.image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
