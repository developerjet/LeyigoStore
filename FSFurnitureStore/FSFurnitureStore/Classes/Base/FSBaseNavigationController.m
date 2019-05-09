//
//  FSBaseNavViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/24.
//  Copyright © 2018 FTS. All rights reserved.
//

#import "FSBaseNavigationController.h"

@interface FSBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation FSBaseNavigationController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigation];
}

- (void)initNavigation {
    
    //设置导航栏下不自动下拉
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏两侧字体颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.delegate = self;
}

+ (void)load
{
    NSArray *array = [NSArray arrayWithObjects:[self class], nil]; //iOS9.0后使用
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:array];
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"FFFFFF"];
    attribute[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    navBar.titleTextAttributes = attribute;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"ic_nav_bgImage"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - <UINavigationControllerDelegate>

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) { //非根控制器才能全屏滑动返回
        UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"ic_nav_back" target:self action:@selector(pop)];
        viewController.navigationItem.leftBarButtonItem = backItem;
        //非根控制器隐藏TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //正式跳转
    [super pushViewController:viewController animated:animated];
}

- (void)pop {
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [self popViewControllerAnimated:YES];
}

@end
