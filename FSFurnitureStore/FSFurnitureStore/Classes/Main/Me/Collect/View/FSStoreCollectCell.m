//
//  FSStoreCollectCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/3.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreCollectCell.h"

@interface FSStoreCollectCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeView;
@end

@implementation FSStoreCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Setter

- (void)setModel:(FSStorePartner *)model {
    _model = model;
    
    self.titleLabel.text = model.name;
    self.nameLabel.text = model.operate;
    self.addressLabel.text = model.address;
    [self.storeView setImage:model.logo placeholder:@"img_empty"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
