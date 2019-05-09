//
//  FSMeInfoHeaderView.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSMeInfoHeaderView.h"

@interface FSMeInfoHeaderView ()

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *userLevelLabel;

@property (nonatomic, strong) UILabel *userNameLable;

@property (nonatomic, strong) UIButton *arrowButton;

@end

@implementation FSMeInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor viewBackGroundColor];
        [self initSubView];
        [self makeLayout];
    }
    return self;
}

- (void)initSubView
{
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.image = [UIImage imageNamed:@"icon_default_avatar"];
    [self addSubview:avatarView];
    self.avatarView = avatarView;
    
    avatarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updatePhotoEvent)];
    [avatarView addGestureRecognizer:tap];
    
    UILabel *userNameLable = [[UILabel alloc] init];
    userNameLable.textColor = [UIColor colorDarkTextColor];
    userNameLable.font = [UIFont systemFontOfSize:16];
    [self addSubview:userNameLable];
    self.userNameLable = userNameLable;
    
    UILabel *userLevelLabel = [[UILabel alloc] init];
    userLevelLabel.textColor = [UIColor colorDarkTextColor];
    userLevelLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:userLevelLabel];
    self.userLevelLabel = userLevelLabel;
    
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.image = @"ic_arrow_01";
    [arrowButton addTarget:self action:@selector(arrowDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:arrowButton];
    self.arrowButton = arrowButton;
}

- (void)makeLayout {
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.height.equalTo(@(100));
    }];
    self.avatarView.layer.cornerRadius = 50.0;
    self.avatarView.layer.masksToBounds = YES;
    
    [self.userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.centerY.equalTo(self).offset(-15);
        make.height.equalTo(@(20));
    }];
    
    [self.userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLable);
        make.height.equalTo(self.userLevelLabel);
        make.centerY.equalTo(self).offset(15);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.height.equalTo(@(34));
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Action

- (void)updatePhotoEvent {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:didUserInfoType:model:)]) {
        
        [self.delegate header:self didUserInfoType:FSMeInfoDidType_Photo model:self.model];
    }
}

- (void)arrowDidEvent:(UIButton *)button {
    if (!self.model) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:didUserInfoType:model:)]) {
        
        [self.delegate header:self didUserInfoType:FSMeInfoDidType_Arrow model:self.model];
    }
}


#pragma mark - Private methods

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.avatarView setImage:imageUrl placeholder:@"icon_default_avatar"];
    });
}

- (void)setModel:(FSLogRegistConfig *)model {
    _model = model;
    
    self.userNameLable.text = model.name;
    self.userLevelLabel.text = model.uname;
    [self.avatarView setImage:model.photo placeholder:@"icon_default_avatar"];
    
    self.arrowButton.hidden = model.name ? NO : YES;
}

@end
