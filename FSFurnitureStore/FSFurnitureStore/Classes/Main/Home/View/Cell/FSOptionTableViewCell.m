//
//  FSOptionTableViewCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSOptionTableViewCell.h"

#define kSpace  1

@interface UIOptionCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) FSHomeSubClass *model;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation UIOptionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWhiteColor];
        
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorDarkTextColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 10;

    CGFloat w1 = 80;
    CGFloat y1 = space;
    CGFloat h1 = self.height - y1 * 2;
    CGFloat x1 = self.width - w1 - space;
    self.imageView.frame = CGRectMake(x1, y1, w1, h1);
    
    CGFloat x2 = space;
    CGFloat h2 = 18;
    CGFloat y2 = (self.height - h2) / 2;
    CGFloat w2 = self.width - w1 - space * 4;
    self.titleLabel.frame = CGRectMake(x2, y2, w2, h2);
}

- (void)setModel:(FSHomeSubClass *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    [self.imageView setImage:model.img placeholder:@"icon_default_image"];
}

@end

@interface FSOptionTableViewCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation FSOptionTableViewCell

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
        [_collectView registerClass:[UIOptionCollectionViewCell class] forCellWithReuseIdentifier:@"kOptionCollectIdentifier"];
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
    
    UIOptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kOptionCollectIdentifier" forIndexPath:indexPath];
    if (self.subClass.count > indexPath.row) {
        cell.model = self.subClass[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.subClass.count > indexPath.row) {
        FSHomeSubClass *model = self.subClass[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(option:didSelectAtModel:)]) {
            [self.delegate option:self didSelectAtModel:model];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemHeight = 98;
    CGFloat itemWidth  = (SCREEN_WIDTH- 3 * kSpace) / 2;
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
