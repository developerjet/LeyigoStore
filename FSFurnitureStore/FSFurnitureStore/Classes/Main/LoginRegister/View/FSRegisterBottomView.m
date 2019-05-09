//
//  FSLogInBottomView.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSRegisterBottomView.h"

@interface FSRegisterBottomView()

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *readButton;

@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation FSRegisterBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorBackGroundColor];
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView
{
    self.readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.readButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.readButton.titleColor = [UIColor colorDarkTextColor];
    self.readButton.selectedImage = @"icon_readed";
    self.readButton.image = @"icon_unread";
    self.readButton.title = @"Reminder：";
    self.readButton.size = 14;
    self.readButton.tag = 1001;
    self.readButton.selected = NO;
    [self.readButton addTarget:self action:@selector(didRegisterEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.readButton];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.textColor = [UIColor colorDarkTextColor];
    self.tipsLabel.text = @"Registration will fill in your personal information, please confirm whether to continue.";
    self.tipsLabel.font = [UIFont systemFontOfSize:14];
    self.tipsLabel.numberOfLines = 3;
    [self addSubview:self.tipsLabel];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerBtn.backgroundColor = [UIColor colorThemeColor];
    self.registerBtn.title = @"Register";
    self.registerBtn.tag = 1002;
    self.registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.registerBtn addTarget:self action:@selector(didRegisterEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.registerBtn];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat spaceY = 15;
    
    CGFloat spaceX = 14;
    CGFloat w1 = 100;
    CGFloat h1 = 20;
    self.readButton.frame = CGRectMake(spaceX, spaceY, w1, h1);
    
    CGFloat x2 = self.readButton.maxX + 5;
    CGFloat h2 = 60;
    CGFloat w2 = self.width - (x2+5) - spaceX;
    self.tipsLabel.frame = CGRectMake(x2, spaceY, w2, h2);
    
    CGFloat w3 = self.width - 60;
    CGFloat h3 = 44;
    CGFloat y3 = self.tipsLabel.maxY + spaceY;
    self.registerBtn.frame = CGRectMake(30, y3, w3, h3);
    self.registerBtn.layer.cornerRadius = 22.0;
    self.readButton.layer.masksToBounds = YES;
}


#pragma mark - Register Event

- (void)didRegisterEvent:(UIButton *)button {
    if (button.tag == 1001) {
        button.selected = !button.selected;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:didRegsiterTag:state:)]) {
        
        [self.delegate view:self didRegsiterTag:button.tag state:button.selected];
    }
}

@end
