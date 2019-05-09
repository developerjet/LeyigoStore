//
//  FSWaitingOrderViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/28.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSWaitingOrderViewController.h"

#import "FSMeShoppingCartController.h"
#import "FSSettlementViewController.h"

#import "FSShopCartList.h"

@interface FSWaitingOrderViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UITextField *numTxView;

@end

@implementation FSWaitingOrderViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _isShopCart ? @"Add shopping cart" : @"Buy now";
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    
    [self configuration];
}

- (void)configuration {
    
    self.nameLabel.text = self.model.name;
    self.buyButton.title = _isShopCart ? @"Add shopping cart" : @"Buy now";
    
    self.numTxView.text = [NSString stringWithFormat:@"%ld", self.model.num];
    self.numTxView.layer.borderColor = [UIColor colorBoardLineColor].CGColor;
    self.numTxView.keyboardType = UIKeyboardTypeNumberPad;
    self.numTxView.layer.borderWidth = 1.0;
    self.numTxView.text = @"1";
    self.numTxView.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - Click

- (IBAction)buttonMinusEvent:(id)sender {
    [self.view endEditing:YES];
    
    self.model.num--;
    if (self.model.num < 1) {
        [FSProgressHUD showHUDWithError:@"Not less than 1" delay:1.0];
        return;
    }
    
    self.numTxView.text = [NSString stringWithFormat:@"%ld", self.model.num];
}

- (IBAction)buttonPlusEvent:(id)sender {
    [self.view endEditing:YES];
    
    self.model.num++;
    if (self.model.num > 100) {
        [FSProgressHUD showHUDWithError:@"Cannot be greater than 100" delay:1.0];
        return;
    }
    
    self.numTxView.text = [NSString stringWithFormat:@"%ld", self.model.num];
}

- (IBAction)shoppingDidEvent:(id)sender {
    if (!self.token) {
        [FSProgressHUD showHUDWithError:@"Please log in first" delay:1.0];
        return;
    }
    if (!self.model) {
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:self.model.idField forKey:@"pid"];
    [p setObject:@(self.model.num) forKey:@"num"];
    [p setObject:self.model.type forKey:@"type"];
    [p setObject:self.token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];
    [p setObject:@"0" forKey:@"gid"];

    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSRequestManager manager] POST:kAdd_ShoppingCart parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
        
        FSHttpResult *result = [FSHttpResult mj_objectWithKeyValues:responseObj];
        if (result.returns == 1) {
            [FSProgressHUD hideHUD];
            if (self.isShopCart) {
                [self showLEEAlert];
            }else {
                [self didSettlement:result.idField];
            }
        }else {
            [FSProgressHUD showHUDWithError:result.message delay:1.0];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)didSettlement:(NSString *)idField {
    
    FSSettlementViewController *settlement = [[FSSettlementViewController alloc] init];
    FSShopCartList *newCart = [FSShopCartList new];
    newCart.num = [NSString stringWithFormat:@"%ld", self.model.num];
    newCart.img = [self.model.photoString firstObject][@"img"];
    newCart.name = self.model.name;
    newCart.idField = idField;
    settlement.dataSource = [NSMutableArray arrayWithObjects:newCart, nil];
    [self.navigationController pushViewController:settlement animated:YES];
}

- (void)showLEEAlert {
    [FSProgressHUD hideHUD];
    
    WeakSelf;
    [LEEAlert alert].config
    .LeeTitle(@"Tips")
    .LeeContent(@"Add shopping cart success")
    .LeeAction(@"Cancel", ^{
        
    })
    .LeeAction(@"ShoppingCart", ^{
        FSMeShoppingCartController *shopCart = [FSMeShoppingCartController new];
        [weakSelf.navigationController pushViewController:shopCart animated:YES];
    })
    .LeeOpenAnimationStyle(LEEAnimationStyleZoomEnlarge | LEEAnimationStyleFade) //这里设置打开动画样式的方向为上 以及淡入效果.
    .LeeCloseAnimationStyle(LEEAnimationStyleZoomShrink | LEEAnimationStyleFade) //这里设置关闭动画样式的方向为下 以及淡出效果
    .LeeShow();
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSInteger num = [textField.text integerValue];
    
    if (num < 1) {
        [FSProgressHUD showHUDWithError:@"Not less than 1" delay:1.0];
        return NO;
    }else if (num > 100) {
        [FSProgressHUD showHUDWithError:@"Cannot be greater than 100" delay:1.0];
        return NO;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger num = [textField.text integerValue];
    
    self.model.num = num;
}

@end
