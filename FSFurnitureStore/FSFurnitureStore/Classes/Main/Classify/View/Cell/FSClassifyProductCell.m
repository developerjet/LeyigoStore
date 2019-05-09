//
//  FSClassifyProductCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSClassifyProductCell.h"

@interface FSClassifyProductCell()

@property (weak, nonatomic) IBOutlet UIImageView *curImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *shiyongLabel;

@property (weak, nonatomic) IBOutlet UILabel *renqiLabel;

@end

@implementation FSClassifyProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

#pragma mark - Setter

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setModel:(FSClassifyRoot *)model {
    _model = model;
    
    self.titleLabel.text = model.name;
    [self.curImgView setImage:model.img placeholder:@"img_empty"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.renqiLabel.text = [NSString stringWithFormat:@"人气：%ld", model.renqi];
    self.shiyongLabel.text = [NSString stringWithFormat:@"最近售出：%ld", model.shiyong];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

