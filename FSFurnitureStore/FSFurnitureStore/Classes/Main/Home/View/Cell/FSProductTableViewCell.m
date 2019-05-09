//
//  FSProductTableViewCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSProductTableViewCell.h"

#define kSpace  1

@interface UIProductCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) FSHomeSubClass *model;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation UIProductCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWhiteColor];
        
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorDarkTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.titleLabel];
        
        self.subtitleLabel = [[UILabel alloc] init];
        self.subtitleLabel.textColor = [UIColor colorDarkTextColor];
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.subtitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 10;
    
    CGFloat x1 = 0;
    CGFloat h1 = 20;
    CGFloat y1 = 5;
    CGFloat w1 = self.width;
    self.titleLabel.frame = CGRectMake(x1, y1, w1, h1);
    
    CGFloat y2 = self.titleLabel.maxY + 5;
    CGFloat h2 = 16;
    self.subtitleLabel.frame = CGRectMake(x1, y2, w1, h2);
    
    CGFloat y3 = self.subtitleLabel.maxY + space;
    CGFloat x3 = space;
    CGFloat w3 = self.width - x3 * 2;
    CGFloat h3 = self.height - y3 - space;
    self.imageView.frame = CGRectMake(x3, y3, w3, h3);
}

- (void)setModel:(FSHomeSubClass *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.name;
    [self.imageView setImage:model.img placeholder:@"icon_default_image"];
}

@end

@interface FSProductTableViewCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation FSProductTableViewCell

- (UICollectionView *)collectView {
    
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        // setup
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.scrollEnabled = NO;
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.backgroundColor = [UIColor colorBackGroundColor];
        [_collectView registerClass:[UIProductCollectionViewCell class] forCellWithReuseIdentifier:@"kProductCollectIdentifier"];
        if (@available(iOS 11.0, *)) {
            _collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectView;
}

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWhiteColor];
        
        [self.contentView addSubview:self.collectView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectView.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.subClass.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kProductCollectIdentifier" forIndexPath:indexPath];
    if (self.subClass.count > indexPath.row) {
        cell.model = self.subClass[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.subClass.count > indexPath.row) {
        FSHomeSubClass *model = self.subClass[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(product:didSelectAtModel:)]) {
            [self.delegate product:self didSelectAtModel:model];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemHeight = 160;
    CGFloat itemWidth  = (SCREEN_WIDTH- 4 * kSpace) / 3;
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(kSpace, kSpace, kSpace, kSpace);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return kSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return kSpace;
}

@end
