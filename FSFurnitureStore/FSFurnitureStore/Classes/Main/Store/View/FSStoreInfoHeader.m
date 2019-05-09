//
//  FSStoreInfoHeader.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/30.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreInfoHeader.h"
#import "JXCategoryView.h"

@interface FSStoreInfoHeader()<JXCategoryViewDelegate>

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FSStoreInfoHeader


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor viewBackGroundColor];
        
        [self initSubview];
    }
    return self;
}

- (void)initSubview {
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"background_dark"];
    [self addSubview:logoView];
    self.logoView = logoView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor colorDarkTextColor];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.numberOfLines = 2;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 10;
 
    CGFloat w1 = 100;
    CGFloat x1 = space;
    CGFloat y1 = space;
    
    self.logoView.frame = CGRectMake(x1, y1, w1, w1);
    
    CGFloat h2 = 40;
    CGFloat x2 = self.logoView.maxX + space;
    CGFloat w2 = self.width - x2 - space;
    CGFloat y2 = (self.height - h2) / 2;
    self.nameLabel.frame = CGRectMake(x2, y2, w2, h2);
}

#pragma mark - Private

- (void)setModel:(FSStorePartner *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    [self.logoView setImage:model.logo placeholder:@"icon_default_avatar"];
}


@end
