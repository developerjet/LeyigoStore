//
//  FSCustomSearchBar.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/27.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSClassifySearchBar.h"

@interface FSClassifySearchBar()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UITextField *searchView;

@end

@implementation FSClassifySearchBar

+ (instancetype)createSearchViewWithFrame:(CGRect)frame delegate:(id<FSCustomSearchviewDelegate>)delegate {
    
    FSClassifySearchBar *searchBar = [[self alloc] initWithFrame:frame];
    searchBar.delegate = delegate;
    return searchBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.title = @"Search";
    [self addSubview:self.doneButton];
    doneButton.backgroundColor = [UIColor colorThemeColor];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [doneButton addTarget:self action:@selector(doneButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    self.doneButton = doneButton;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    UITextField *searchView = [[UITextField alloc] init];
    searchView.delegate = self;
    searchView.borderStyle = UITextBorderStyleNone;
    searchView.leftViewMode = UITextFieldViewModeAlways;
    searchView.leftView = leftView;
    searchView.font = [UIFont systemFontOfSize:17];
    searchView.backgroundColor = [UIColor colorWhiteColor];
    [self addSubview:searchView];
    self.searchView = searchView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 10;
    
    CGFloat w1 = 70;
    CGFloat x1 = self.width - w1 - space;
    CGFloat h1 = 36;
    CGFloat y1 = (self.height - h1) / 2;
    self.doneButton.frame = CGRectMake(x1, y1, w1, h1);
    self.doneButton.layer.cornerRadius = h1 * 0.5;
    self.doneButton.layer.masksToBounds = YES;
    
    CGFloat h2 = 44;
    CGFloat y2 = (self.height - h2) / 2;
    CGFloat w2 = self.width - w1 - space * 3;
    self.searchView.frame = CGRectMake(space, y2, w2, h2);
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    
    self.searchView.placeholder = placeholder;
}


- (void)doneButtonEvent {
    [self.searchView endEditing:YES];
    
    if (self.searchView.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(search:textFieldDidEndEditing:)]) {
            [self.delegate search:self textFieldDidEndEditing:self.searchView.text];
        }
        self.searchView.text = @"";
    }else {
        [FSProgressHUD showHUDWithText:@"Please fill in the search" delay:1.0];
    }
}

@end
