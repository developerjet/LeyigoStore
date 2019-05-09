//
//  FSNewOptionContentCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSNewOptionContentCell.h"

@interface FSNewOptionContentCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *curImageView;

@end

@implementation FSNewOptionContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(FSNewOptionClass *)model {
    _model = model;
    
    self.dateLabel.text = model.time;
    self.titleLabel.text = model.name;
    self.contentLabel.text = model.digest;
    [self.curImageView setImage:model.photo placeholder:@"img_empty"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
