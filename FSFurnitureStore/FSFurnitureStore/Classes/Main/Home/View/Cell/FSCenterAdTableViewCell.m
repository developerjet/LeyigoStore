//
//  FSCenterAdTableViewCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSCenterAdTableViewCell.h"

@interface FSCenterAdTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *curImageView;


@end

@implementation FSCenterAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.curImageView.backgroundColor = [UIColor blueColor];
}

- (void)setModel:(FSHomeSubClass *)model {
    
    _model = model;
    
    [self.curImageView setImage:model.img placeholder:@"icon_loading_image"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
