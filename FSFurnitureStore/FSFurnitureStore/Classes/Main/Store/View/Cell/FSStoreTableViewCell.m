//
//  FSStoreTableViewCell.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/29.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSStoreTableViewCell.h"
#import "FSStoreProductCell.h"

#define SPACE 10

@interface FSStoreTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotoButton;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectHeight;
@end

@implementation FSStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self loadSubView];
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectView setCollectionViewLayout:layout];
    
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.backgroundColor = [UIColor colorWhiteColor];
    [self.collectView registerNib:[UINib nibWithNibName:@"FSStoreProductCell" bundle:nil] forCellWithReuseIdentifier:@"kStoreProductIdentifier"];
    
    self.gotoButton.layer.cornerRadius = 15.0;
    self.gotoButton.layer.masksToBounds = YES;
    self.gotoButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
}

#pragma mark - Private setter

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (void)setModel:(FSStorePartner *)model {
    _model = model;
    
    self.titleLabel.text = model.name;
    self.telPhoneLabel.text = model.tel;
    self.contactLabel.text = model.operate;
    self.addressLabel.text = model.address;
    [self.logoImageView setImage:model.logo placeholder:@"img_empty"];
    
    self.collectHeight.constant = model.subclass.count ? 99.5 : 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.subclass.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FSStoreProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kStoreProductIdentifier" forIndexPath:indexPath];
    if (self.model.subclass.count > indexPath.row) {
        cell.model = [FSStoreSubclas mj_objectWithKeyValues:self.model.subclass[indexPath.row]];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.model.subclass.count > indexPath.row) {
        
        FSStoreSubclas *subclas = [FSStoreSubclas mj_objectWithKeyValues:self.model.subclass[indexPath.row]];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectItemAtModel:)]) {
            
            [self.delegate cell:self didSelectItemAtModel:subclas];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemHeight = 80;
    CGFloat itemWidth = (SCREEN_WIDTH - 5 * SPACE) / 4;
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(SPACE, SPACE, SPACE, SPACE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return SPACE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return SPACE;
}

@end
