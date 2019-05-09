//
//  FSShopCartInfoCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSShoppingCartInfoCell.h"

@interface FSShoppingCartInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *productView;
@end

@implementation FSShoppingCartInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.selectButton.userInteractionEnabled = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Private

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setModel:(FSShopCartList *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    [self.productView setImage:model.img placeholder:@"img_empty"];
    self.numberLabel.text = [NSString stringWithFormat:@"count: %@", model.num];
    
    self.selectButton.selected = model.isSelect;
}

- (void)setHideAdd:(BOOL)hideAdd {
    _hideAdd = hideAdd;
    
    self.addButton.hidden = hideAdd;
    self.selectButton.hidden = hideAdd;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action

- (IBAction)addCountEvent:(id)sender {
    
    if (self.model) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didAddCountAtModel:)]) {
            
            [self.delegate cell:self didAddCountAtModel:self.model];
        }
    }
}


@end
