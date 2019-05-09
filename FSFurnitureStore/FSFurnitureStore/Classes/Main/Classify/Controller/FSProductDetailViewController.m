//
//  FSProductDetailViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSProductDetailViewController.h"
#import "FSProductClass.h"

#import "FSWaitingOrderViewController.h"
#import "FSBaseBrowserViewController.h"
#import "FSStoreDetailBaseController.h"

#import "FSProductCommentController.h"

@interface FSProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *productLabel;

@property (weak, nonatomic) IBOutlet UIImageView *productView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTopLayout;

@property (nonatomic, strong) FSProductClass *productClass;

@property (nonatomic, strong) UIButton *starButton;

@end

@implementation FSProductDetailViewController

#pragma mark - Lazy

- (FSProductClass *)productClass {
    
    if (!_productClass) {
        
        _productClass = [[FSProductClass alloc] init];
    }
    return _productClass;
}

- (UIButton *)starButton {
    
    if (!_starButton) {
        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starButton setImage:[UIImage imageNamed:@"ic_star_normal"] forState:UIControlStateNormal];
        [_starButton setImage:[UIImage imageNamed:@"ic_star_selected"] forState:UIControlStateSelected];
        [_starButton addTarget:self action:@selector(productToAdd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _starButton;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Product detail";
    self.scrollTopLayout.constant = iPhoneX ? 88 : 64;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.starButton];
    self.starButton.hidden = self.isCollect ? NO : YES;
    
    [self initClassView];
    [self requestClasses];
}

- (void)initClassView {
    
    self.priceLabel.text = self.model.price;
    self.productLabel.text = self.model.name;
    [self.productView setImage:self.model.img placeholder:@"img_empty"];
}

#pragma mark - Request

- (void)requestClasses {
    if (![FSLoginManager manager].token) {
        [FSProgressHUD showHUDWithText:@"Please login again" delay:2.0];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:self.model.idField forKey:@"id"];
    [p setObject:@"3406" forKey:@"appkey"];
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kClassify_Product parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        NSDictionary *JSONObject = [responseObj mj_JSONObject];
        if ([responseObj[@"returns"] integerValue] == 1) {
            [FSProgressHUD hideHUD];
            self.productClass = [FSProductClass mj_objectWithKeyValues:JSONObject];
            self.productClass.idField = self.model.idField;
            self.productClass.num = 1; //初始化
        }else {
            self.productClass = [FSProductClass new];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}


- (void)productToAdd {
    if (![FSLoginManager manager].token.length) {
        [FSProgressHUD showHUDWithLongText:@"please login" delay:1.0];
        [self goToLogin];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:[FSLoginManager manager].token forKey:@"token"];
    [p setObject:self.model.idField forKey:@"id"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"add" forKey:@"type"];
    
    [[FSRequestManager manager] POST:kStore_Collect parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        if ([responseObj[@"returns"] integerValue] == 1) {
            self.starButton.selected = YES;
        }else {
            [FSProgressHUD showHUDWithText:responseObj[@"message"] delay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

#pragma mark - Click

- (IBAction)addShopCart:(id)sender {
    if (![FSLoginManager manager].token.length) {
        [FSProgressHUD showHUDWithText:@"Please login again" delay:1.0];
        [self goToLogin];
        return;
    }
    if (!self.productClass.idField.length) {
        return;
    }
    
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    FSWaitingOrderViewController *orderVC = [FSWaitingOrderViewController new];
    orderVC.model = self.productClass;
    orderVC.isShopCart = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)quickNowBuy:(id)sender {
    if (![FSLoginManager manager].token.length) {
        [FSProgressHUD showHUDWithText:@"Please login again" delay:2.0];
        [self goToLogin];
        return;
    }
    if (!self.productClass.idField.length) {
        return;
    }
    
    FSWaitingOrderViewController *orderVC = [FSWaitingOrderViewController new];
    orderVC.model = self.productClass;
    orderVC.isShopCart = NO;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)didCommentEvent:(id)sender {
    if(![FSLoginManager manager].token.length) {
        [FSProgressHUD showHUDWithText:@"Please login again" delay:2.0];
        return;
    }
    
    if (!self.productClass.idField.length) {
        return;
    }
    
    FSProductCommentController *commentVC = [[FSProductCommentController alloc] init];
    commentVC.model = self.productClass;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (IBAction)lookDetail:(id)sender {
    if (!self.productClass.concent.length) {
        return;
    }
    
    FSBaseBrowserViewController *browser = [FSBaseBrowserViewController new];
    browser.title = self.productClass.name;
    browser.URLString = self.productClass.concent;
    [self.navigationController pushViewController:browser animated:YES];
}

- (IBAction)didShareEvent:(id)sender {
    if(![FSLoginManager manager].token.length) {
        [FSProgressHUD showHUDWithText:@"Please login again" delay:2.0];
        return;
    }
    
    [self showUMengShare];
}

- (IBAction)callPhone:(id)sender {
    if (!self.productClass.partnerTel.length) {
        return;
    }
    
    NSMutableString * URLString = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.productClass.partnerTel];
    UIWebView * callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
    [self.view addSubview:callWebView];
}

- (IBAction)goToStore:(id)sender {
    if (!self.productClass.idField.length) {
        return;
    }
    
    FSStoreDetailBaseController *storeVC = [[FSStoreDetailBaseController alloc] init];
    FSStorePartner *partner = [FSStorePartner new];
    partner.logo = [self.productClass.photoString firstObject][@"img"];
    partner.idField = self.productClass.idField;
    partner.name = self.productClass.partner;
    storeVC.model = partner;
    [self.navigationController pushViewController:storeVC animated:YES];
}


#pragma mark - UMeng Share

- (void)showUMengShare
{
    UIImage *imageQQ = [self bundleImageNamed:@"umsocial_qq"];
    UIImage *imageWechat = [self bundleImageNamed:@"umsocial_wechat"];
    UIImage *imageTimeline = [self bundleImageNamed:@"umsocial_wechat_timeline"];
    UIImage *imageSina = [self bundleImageNamed:@"umsocial_sina"];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_QQ withPlatformIcon:imageQQ withPlatformName:@"QQ"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatSession withPlatformIcon:imageWechat withPlatformName:@"Wechat"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatTimeLine withPlatformIcon:imageTimeline withPlatformName:@"TimeLine"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Sina withPlatformIcon:imageSina withPlatformName:@"Weibo"];
    
    //显示分享面板
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    if (!self.productClass.idField) return;
    
    NSString *newShareURL = [NSString stringWithFormat:@"http://115.28.153.171/vmall/wap/detal.php?appkey=3406&id=%@&fun=0&s=221", self.productClass.idField];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UIImage *thumImage = [UIImage imageNamed:@"ic_app_logo"];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"Welcome to use LeyiGo Store" descr:@"Your wonderful home life will begin here." thumImage:thumImage];
    //设置网页地址
    shareObject.webpageUrl = newShareURL;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            if (platformType == UMSocialPlatformType_QQ) {
                [self showShareError:@"QQ did not install"];
            }else if (platformType == UMSocialPlatformType_WechatSession ||
                      platformType == UMSocialPlatformType_WechatTimeLine) {
                [self showShareError:@"Wechat did not install"];
            }
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
    }];
}

- (void)showShareError:(NSString *)msg
{
    [LEEAlert alert].config
    .LeeTitle(@"kindly reminder")
    .LeeContent(msg)
    .LeeAction(@"OK", ^{
    })
    .LeeOpenAnimationStyle(LEEAnimationStyleOrientationTop | LEEAnimationStyleFade) //这里设置打开动画样式的方向为上 以及淡入效果.
    .LeeCloseAnimationStyle(LEEAnimationStyleOrientationBottom | LEEAnimationStyleFade) //这里设置关闭动画样式的方向为下 以及淡出效果
    .LeeShow();
}

- (UIImage *)bundleImageNamed:(NSString *)imageName
{
    NSString *imagePath = [NSString stringWithFormat:@"UMSocialSDKResources.bundle/UMSocialPlatformTheme/default/%@", imageName];
    NSString *contentsOfFile = [[NSBundle mainBundle] pathForResource:imagePath ofType:@"png"];
    return [[UIImage imageWithContentsOfFile:contentsOfFile] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}



@end
