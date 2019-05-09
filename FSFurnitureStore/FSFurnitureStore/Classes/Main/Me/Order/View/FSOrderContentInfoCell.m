//
//  FSOrderContentInfoCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/3.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSOrderContentInfoCell.h"

@interface FSOrderContentInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;

@property (weak, nonatomic) IBOutlet UIImageView *productView;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation FSOrderContentInfoCell

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
    
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorBoardLineColor].CGColor;
}

#pragma mark - setter

- (void)setModel:(FSOrderInfoList *)model {
    _model = model;
    NSString *imageURL = [model.img firstObject][@"img"];
    
    self.statusLabel.text = model.status;
    [self.productView setImage:imageURL placeholder:@"img_empty"];
    self.orderNumLab.text = [NSString stringWithFormat:@"OrderID：%@", model.idField];
    self.countLabel.text = [NSString stringWithFormat:@"%@ products in total", model.num];
    
    self.selectButton.selected = model.isSelect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
