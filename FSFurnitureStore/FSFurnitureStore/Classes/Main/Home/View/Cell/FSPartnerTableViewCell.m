//
//  FSPartnerTableViewCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/26.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSPartnerTableViewCell.h"

#import "FSPartnerCollectCell.h"

#define spacing 1

@interface FSPartnerTableViewCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation FSPartnerTableViewCell

#pragma mark - Lazy

- (UICollectionView *)collectView {
    
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        // setup
        _collectView.delegate = self;
        _collectView.scrollEnabled = NO;
        _collectView.dataSource = self;
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.backgroundColor = [UIColor colorBackGroundColor];
        [_collectView registerClass:[FSPartnerCollectCell class] forCellWithReuseIdentifier:@"kPartnerCollectIdentifier"];
        
        if (@available(iOS 11.0, *)) {
            _collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectView;
}

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.collectView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectView.frame = self.bounds;
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
    
    FSPartnerCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kPartnerCollectIdentifier" forIndexPath:indexPath];
    if (self.subClass.count > indexPath.row) {
        cell.model = self.subClass[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.subClass.count > indexPath.row) {
        FSHomeSubClass *model = self.subClass[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:DidSelectAtModel:)]) {
            [self.delegate cell:self DidSelectAtModel:model];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemHeight = 98;
    CGFloat itemWidth  = (SCREEN_WIDTH- 3 * spacing) / 2;
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return spacing;
}

@end
