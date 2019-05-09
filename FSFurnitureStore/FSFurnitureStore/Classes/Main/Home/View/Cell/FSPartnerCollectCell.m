//
//  FSPartnerCollectCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSPartnerCollectCell.h"

@interface FSPartnerCollectCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) SDCycleScrollView *scrollView;

@end

@implementation FSPartnerCollectCell

- (SDCycleScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[SDCycleScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _scrollView.placeholderImage = [UIImage imageNamed:@"background_dark"];
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWhiteColor];
        
        [self loadView];
    }
    return self;
}


- (void)loadView
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"EE2C2C"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.textColor = [UIColor colorDarkTextColor];
    [self.contentView addSubview:self.subtitleLabel];
    
    [self.contentView addSubview:self.scrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat space = 10;
    
    CGFloat h1 = 90;
    CGFloat w1 = 60;
    CGFloat y1 = (self.height - h1) / 2;
    CGFloat x1 = self.width - w1 - space;
    self.scrollView.frame = CGRectMake(x1, y1, w1, h1);
    
    CGFloat x2 = space;
    CGFloat y2 = 5;
    CGFloat w2 = self.width - w1 - 4 * space;
    CGFloat h2 = 20 * 2;
    self.titleLabel.frame = CGRectMake(x2, y2, w2, h2);
    
    CGFloat h3 = 15;
    CGFloat y3 = self.titleLabel.maxY + 5;
    self.subtitleLabel.frame = CGRectMake(x2, y3, w2, h3);
}


#pragma mark - Private setter

- (void)setModel:(FSHomeSubClass *)model {
    _model = model;
    if (!model) return;
    
    self.titleLabel.text = model.name;
    self.subtitleLabel.text = model.guanggao;
    NSMutableArray *newImages = [NSMutableArray arrayWithObjects:model.bz_1, model.bz_2, model.bz_3, nil];
    self.scrollView.imageURLStringsGroup = newImages;
}



@end
