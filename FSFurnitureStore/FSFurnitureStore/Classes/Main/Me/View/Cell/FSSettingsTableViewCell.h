//
//  FSSettingsTableViewCell.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, strong) FSBaseModel *model;

@end

NS_ASSUME_NONNULL_END
