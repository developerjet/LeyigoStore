//
//  FSAddressInfoCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/3.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSAddressManagerCell.h"

@interface FSAddressManagerCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation FSAddressManagerCell

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor viewBackGroundColor];
    self.addressLabel.numberOfLines = 2;
    
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [UIColor colorBoardLineColor].CGColor;
    self.layer.masksToBounds = YES;
}

- (void)setModel:(FSShopCartList *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.tel;
    self.addressLabel.text = model.address;
    self.selectButton.selected = model.isSelect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
