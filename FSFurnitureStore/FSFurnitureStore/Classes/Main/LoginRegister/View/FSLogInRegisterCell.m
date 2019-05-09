//
//  FSLogInRegisterCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSLogInRegisterCell.h"

@interface FSLogInRegisterCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *rightHUDView;

@end

@implementation FSLogInRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField.delegate = self;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.height)];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    
    self.rightHUDView.hidden = YES;
    self.rightHUDView.backgroundColor = [UIColor clearColor];
}

#pragma mark - setter

- (void)setShowHUD:(BOOL)showHUD {
    _showHUD = showHUD;
    
    self.rightHUDView.hidden = !showHUD;
}

- (void)setModel:(FSLogRegistConfig *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.textField.placeholder = model.placeholder;
    self.textField.text = model.subtitle ? model.subtitle : model.text;
    self.textField.secureTextEntry = model.secureTextEntry;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.textField]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:textFieldDidEndEditing:)]) {
            
            [self.delegate cell:self textFieldDidEndEditing:textField.text];
        }
    }
}

@end
