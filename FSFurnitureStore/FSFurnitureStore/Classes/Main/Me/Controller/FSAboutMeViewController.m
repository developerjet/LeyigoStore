//
//  FSAboutMeViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/5.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSAboutMeViewController.h"

@interface FSAboutMeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoSubView;

@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@end

@implementation FSAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"About Me";
    
    [self configuration];
}

- (void)configuration {
    
    self.logoSubView.layer.cornerRadius = 5.0;
    self.logoSubView.layer.masksToBounds = YES;
    
    self.versionLab.text = [NSString stringWithFormat:@"Version:%@", kBundleVersion];
}

@end
