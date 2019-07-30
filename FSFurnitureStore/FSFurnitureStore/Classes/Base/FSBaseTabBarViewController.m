//
//  FSBaseTabBarViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/24.
//  Copyright © 2018 FTS. All rights reserved.
//

#import "FSBaseTabBarViewController.h"
#import "FSBaseNavigationController.h"

#import "FSHomeViewController.h"
#import "FSClassifyViewController.h"
#import "FSStoreViewController.h"
#import "FSMeInfoViewController.h"

@interface FSBaseTabBarViewController ()

@end

@implementation FSBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
}

+ (void)load
{
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *normalAttribute = [NSMutableDictionary dictionary];
    normalAttribute[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Semibold" size:11];
    normalAttribute[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"A9A9A9"];
    [item setTitleTextAttributes:normalAttribute forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedAttribute = [NSMutableDictionary dictionary];
    selectedAttribute[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Semibold" size:11];
    selectedAttribute[NSForegroundColorAttributeName] = [UIColor colorThemeColor];
    [item setTitleTextAttributes:selectedAttribute forState:UIControlStateSelected];
    
    // 设置tabBar背景颜色
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FAFAFA"]]];
    [UITabBar appearance].translucent = NO;
}

- (void)initControllers
{
    FSHomeViewController *vc1 = [[FSHomeViewController alloc] init];
    [self createChildController:vc1 title:@"Home" image:@"ic_tabBar_1-1" selectedImage:@"ic_tabBar_1-2"];
    
    FSClassifyViewController *vc2 = [[FSClassifyViewController alloc] init];
    [self createChildController:vc2 title:@"Class" image:@"ic_tabBar_2-1" selectedImage:@"ic_tabBar_2-2"];
    
    FSStoreViewController *vc3 = [[FSStoreViewController alloc] init];
    [self createChildController:vc3 title:@"Store" image:@"ic_tabBar_3-1" selectedImage:@"ic_tabBar_3-2"];
    
    FSMeInfoViewController *vc4 = [[FSMeInfoViewController alloc] init];
    [self createChildController:vc4 title:@"Me" image:@"ic_tabBar_4-1" selectedImage:@"ic_tabBar_4-2"];
    
    // 默认选中首页
    self.selectedIndex = 0;
}

- (void)createChildController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    FSBaseNavigationController *nav = [[FSBaseNavigationController alloc] initWithRootViewController:vc];
    if (title && image && selectedImage) {
        vc.tabBarItem.title = title;
        vc.tabBarItem.image = [UIImage imageWithOriginalRenderingMode:image];
        vc.tabBarItem.selectedImage = [UIImage imageWithOriginalRenderingMode:selectedImage];
    }
    [self addChildViewController:nav];
}

@end
