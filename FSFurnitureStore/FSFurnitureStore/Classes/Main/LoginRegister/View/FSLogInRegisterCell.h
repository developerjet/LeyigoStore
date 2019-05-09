//
//  FSLogInRegisterCell.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLogRegistConfig.h"

NS_ASSUME_NONNULL_BEGIN
@class FSLogInRegisterCell;
@protocol FSLogInRegisterCellDelegate <NSObject>
@optional
- (void)cell:(FSLogInRegisterCell *)cell textFieldDidEndEditing:(NSString *)text;
@end

@interface FSLogInRegisterCell : UITableViewCell

@property (nonatomic, strong) FSLogRegistConfig *model;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, weak) id<FSLogInRegisterCellDelegate> delegate;

@property (nonatomic, assign) BOOL showHUD;

@end

NS_ASSUME_NONNULL_END
