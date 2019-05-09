//
//  FSHomeBannerHeader.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/25.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSHomeBannerHeader.h"

#define kItemHeight 80

@interface FSItemButton : UIButton
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *coloe;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *logoView;
@end

@implementation  FSItemButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.logoView = [[UIImageView alloc] init];
        [self addSubview:self.logoView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor colorDarkTextColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 10;
    
    CGFloat h1 = self.width * 0.4;
    CGFloat w1 = h1;
    CGFloat x1 = (self.width - w1) / 2;
    self.logoView.frame = CGRectMake(x1, space, w1, h1);
    
    CGFloat h2 = 20;
    CGFloat y2 = self.logoView.maxY + 5;
    self.textLabel.frame = CGRectMake(0, y2, self.width, h2);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.textLabel.text = title;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    if ([url containsString:@"http"]) {
        [self.logoView setImage:url placeholder:@"background_dark"];
    }else {
        self.logoView.image = [UIImage imageNamed:url];
    }
}


@end

@interface FSHomeBannerHeader()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) SDCycleScrollView *cycleView;

@property (nonatomic, strong) NSArray <FSBaseModel *> *customImages;

@property (nonatomic, strong) NSArray <NSString *> *customBanners;

@end

@implementation FSHomeBannerHeader

#pragma mark - Lazy

- (SDCycleScrollView *)cycleView {
    
    if (!_cycleView) {
        _cycleView = [[SDCycleScrollView alloc] initWithFrame:self.bounds];
        _cycleView.currentPageDotColor = [UIColor whiteColor];
        _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleView.placeholderImage = [UIImage imageNamed:@"icon_loading_image"];
        _cycleView.pageControlDotSize = CGSizeMake(5, 5);
    }
    return _cycleView;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (NSArray<FSBaseModel *> *)customImages {
    
    if (!_customImages) {
        
        _customImages = @[[FSBaseModel initImage:@"ic_home_hot" title:@"Hot"],
                          [FSBaseModel initImage:@"ic_home_dongtai" title:@"Dynamic"],
                          [FSBaseModel initImage:@"ic_home_zhengce" title:@"Regulations"],
                          [FSBaseModel initImage:@"ic_home_more" title:@"More"]];
    }
    return _customImages;
}

- (NSArray<NSString *> *)customBanners {
    
    if (!_customBanners) {
        
        _customBanners = @[@"http://img3.selfimg.com.cn/Lad193/2018/09/28/1538116183_o1JLlK.jpg",
                           @"http://img1.selfimg.com.cn/Lad193/2018/09/28/1538120997_DnjkCn.jpg",
                           @"http://www.hola.com.cn/public/images/ad/d8/bb/3d14269b6d9fb2468d9954bf085bd688.jpg?1540411729#w",
                           @"http://www.hola.com.cn/public/images/3d/7e/31/495e31f9bbc61468d0d4541fe537e40e.jpg?1540411699#w",
                           @"http://www.offsup.net/file/upload/201707/27/164506601.jpg",
                           @"http://static.01homecdn.com/pigimg/20181130/15435724087472222.jpg"];
    }
    return _customBanners;
}

#pragma mark - initial

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.backgroundColor = [UIColor colorWhiteColor];        
        [self adjustLayout];
    }
    
    return self;
}

- (void)adjustLayout {
    
    CGFloat h1 = self.height - kItemHeight;
    self.cycleView.frame = CGRectMake(0, 0, self.width, h1);
    [self addSubview:self.cycleView];
    
    CGFloat y2 = self.cycleView.maxY;
    CGFloat h2 = kItemHeight;
    self.contentView.frame = CGRectMake(0, y2, self.width, h2);
    [self addSubview:self.contentView];
}

#pragma mark - setter

- (void)setImages:(NSMutableArray<FSHomeSubClass *> *)images {
    _images = images;
    if (!images || !images.count) {
        return;
    }

    self.cycleView.imageURLStringsGroup = self.customBanners;
}

- (void)setItems:(NSMutableArray<FSHomeSubClass *> *)items {
    _items = items;
    if (!items || !items.count) {
        return;
    }

    CGFloat height = self.contentView.height;
    CGFloat width = SCREEN_WIDTH / items.count;
    
    if (items.count == self.customImages.count) {
        [self.customImages enumerateObjectsUsingBlock:^(FSBaseModel * _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
            FSBaseModel *mode = self.customImages[idx];
            FSItemButton *button = [FSItemButton new];
            button.url = mode.image;
            button.title = mode.title;
            button.frame = CGRectMake(width * idx, 0, width, height);
            [self.contentView addSubview:button];
            button.tag = idx;
            [button addTarget:self action:@selector(subClassDidEvent:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}

#pragma mark - Action

- (void)subClassDidEvent:(UIButton *)button {
    FSHomeSubClass *sub = self.items[button.tag];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:DidSelectAtSubClass:)]) {
        [self.delegate header:self DidSelectAtSubClass:sub];
    }
}

@end
