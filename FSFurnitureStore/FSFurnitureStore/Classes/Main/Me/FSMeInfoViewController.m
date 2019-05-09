//
//  FSMeViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/24.
//  Copyright © 2018 FTS. All rights reserved.
//

#import "FSMeInfoViewController.h"
#import "FSLoginViewController.h"
#import "FSMeInfoTableViewCell.h"
#import "FSMeInfoHeaderView.h"

#import "FSAddressManagerController.h"
#import "FSStoreCollectViewController.h"
#import "FSMeShoppingCartController.h"
#import "FSProductCollectController.h"
#import "FSOrderListViewController.h"
#import "FSSettingsViewController.h"
#import "FSMeInfoUpdateController.h"

#import "TZImagePickerController.h"

static NSString *const kMeInfoCellIdentifier = @"kMeInfoCellIdentifier";

@interface FSMeInfoViewController()
<FSMeInfoHeaderDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) FSMeInfoHeaderView *headerView;

@end

@implementation FSMeInfoViewController

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = @[@[[FSBaseModel initImage:@"ic_me_01" title:@"Shopping cart"],
                          [FSBaseModel initImage:@"ic_me_02" title:@"My orders"],
                          [FSBaseModel initImage:@"ic_me_03" title:@"Store collect"],
                          [FSBaseModel initImage:@"ic_me_04" title:@"Product collect"],
                          [FSBaseModel initImage:@"ic_me_05" title:@"Logistics"]],
                        @[[FSBaseModel initImage:@"ic_me_06" title:@"Settings"]]];
    }
    return _dataSource;
}

- (UIButton *)rightButton {
    
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _rightButton.backgroundColor = [UIColor colorWithHexString:@"FF4500"];
        _rightButton.frame = CGRectMake(0, 0, 62, 30);
        _rightButton.layer.cornerRadius = 15.0;
        _rightButton.layer.masksToBounds = YES;
        _rightButton.hidden = YES;
        _rightButton.title = @"Login";
        [_rightButton addTarget:self action:@selector(rightDidEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (FSMeInfoHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[FSMeInfoHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"User";
    self.view.backgroundColor = [UIColor viewBackGroundColor];
    self.rightButton.hidden = [FSLoginManager manager].token.length ? YES : NO;
    
    [NC addObserver:self selector:@selector(requestInfo) name:NC_LOGIN_SUCCESS object:nil];
    [NC addObserver:self selector:@selector(reloadItem) name:NC_LOGOUT_SUCCESS object:nil];
    
    [self initSubView];
    [self requestInfo];
}

- (void)initSubView {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    CGFloat height = SCREEN_HEIGHT - kNavHeight - kTabBarHeight;
    self.groupedTable.frame = CGRectMake(0, kNavHeight, SCREEN_WIDTH, height);
    [self.groupedTable registerNib:[UINib nibWithNibName:@"FSMeInfoTableViewCell" bundle:nil] forCellReuseIdentifier:kMeInfoCellIdentifier];
    self.groupedTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.groupedTable.tableHeaderView = self.headerView;
    [self.view addSubview:self.groupedTable];
}

#pragma mark - Networking

- (void)requestInfo {
    if (![FSLoginManager manager].token) {
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:self.token forKey:@"token"];
    [p setObject:@"3406" forKey:@"appkey"];

    [[FSRequestManager manager] POST:kUser_Info parameters:p success:^(id  _Nullable responseObj) {
        if (!responseObj || ![responseObj isKindOfClass:[NSDictionary class]]) {
            [FSProgressHUD hideHUD];
            return;
        }
    
        if ([responseObj[@"returns"] integerValue] == 1) {
            FSLogRegistConfig *info = [FSLogRegistConfig mj_objectWithKeyValues:responseObj[@"info"]];
            self.rightButton.hidden = YES;
            self.headerView.model = info;
            [FSLoginManager manager].info = info;
        }else {
            [self updateToken];
            self.rightButton.hidden = NO;
            [FSProgressHUD showHUDWithText:@"Please login again" delay:1.0];
            [self goToLogin];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)uploadAvatarWithData:(NSData *)imageData {
    if (!imageData || !imageData.length) return;
    
    WeakSelf;
    [FSProgressHUD showHUDWithIndeterminate:@"Loading..."];
    [[FSUploadConfig config] uploadImageWithData:imageData success:^(id  _Nonnull response) {
        if (response || [response isKindOfClass:[NSDictionary class]]) {
            FSHttpResult *JSONObject = [FSHttpResult mj_objectWithKeyValues:response];
            if (JSONObject.returns == 1) {
                [FSProgressHUD showHUDWithSuccess:@"Success" delay:1.0];
                weakSelf.headerView.imageUrl = JSONObject.message;
            }else {
                [FSProgressHUD showHUDWithError:JSONObject.message delay:1.0];
            }
            NSLog(@"response --- %@", [response mj_JSONObject]);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [FSProgressHUD hideHUD];
    }];
}

- (void)updateToken {
    
    [FSLoginManager manager].token = @"";
    [UD setObject:@"" forKey:UD_USER_TOKEN];
    [UD synchronize];
}

- (void)reloadItem {
    
    self.rightButton.hidden = NO;
    self.headerView.model = [FSLogRegistConfig new];
}

#pragma mark - Action

- (void)rightDidEvent {
    
    if (![FSLoginManager manager].token.length) {
        [self goToLogin];
    }
}

- (void)openCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES; //设置为可编辑
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        [LEEAlert alert].config
        .LeeTitle(@"温馨提示")
        .LeeContent(@"当前设备没有可用的摄像头")
        .LeeAction(@"OK", ^{
            // 点击事件Block
        })
        .LeeOpenAnimationStyle(LEEAnimationStyleZoomEnlarge | LEEAnimationStyleFade) //这里设置打开动画样式的方向为上 以及淡入效果.
        .LeeCloseAnimationStyle(LEEAnimationStyleZoomShrink | LEEAnimationStyleFade) //这里设置关闭动画样式的方向为下 以及淡出效果
        .LeeShow();
    }
}


- (void)openAlbum
{
    WeakSelf;
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.showSelectBtn = NO;
    imagePicker.allowCrop = YES; //允许裁剪
    imagePicker.needCircleCrop = YES; //圆形裁剪
    CGFloat width = SCREEN_WIDTH * 0.8;
    CGFloat x = (imagePicker.view.width - width) / 2;
    CGFloat y = (imagePicker.view.height - width) / 2;
    imagePicker.cropRectPortrait = CGRectMake(x, y, width, width);
    imagePicker.circleCropRadius = width * 0.5;
    imagePicker.navigationBar.barTintColor = [UIColor colorThemeColor];
    
    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *firstImage = [photos firstObject];
        UIImage *maxImage = [firstImage imageToImageMaxWidthOrHeight:600];
        NSData *imageData = UIImagePNGRepresentation(maxImage);
        [weakSelf uploadAvatarWithData:imageData];
    }];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - <FSMeInfoHeaderDelegate>

- (void)header:(FSMeInfoHeaderView *)header didUserInfoType:(FSMeInfoDidType)type model:(FSLogRegistConfig *)model {
    if (![FSLoginManager manager].token.length) return;
    
    if (type == FSMeInfoDidType_Arrow) {
        FSMeInfoUpdateController *updateInfo = [[FSMeInfoUpdateController alloc] init];
        [self.navigationController pushViewController:updateInfo animated:YES];
    }else {
        [self showSheet];
    }
}

- (void)showSheet {
    
    WeakSelf;
    [LEEAlert actionsheet].config
    .LeeAction(@"Tack Photo ", ^{
        [weakSelf openCamera];
    })
    .LeeAction(@"Choose from album", ^{
        [weakSelf openAlbum];
    })
    .LeeCancelAction(@"Clean", ^{
        // 点击事件Block
    })
    .LeeShow();
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSMeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMeInfoCellIdentifier];
    if (self.dataSource.count > indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.model = self.dataSource[indexPath.section][indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self goTargetVC:[[FSMeShoppingCartController alloc] init]];
        }else if (indexPath.row == 1) {
            [self goTargetVC:[[FSOrderListViewController alloc] init]];
        }else if (indexPath.row == 2) {
            [self goTargetVC:[[FSStoreCollectViewController alloc] init]];
        }else if (indexPath.row == 3) {
            [self goTargetVC:[[FSProductCollectController alloc] init]];
        }else {
            [self goTargetVC:[[FSAddressManagerController alloc] init]];
        }
    }else {
        [self goTargetVC:[[FSSettingsViewController alloc] init]];
    }
}

- (void)goTargetVC:(UIViewController *)vc {
    if (!vc) return;
    
    if (![FSLoginManager manager].token.length) {
        if (![vc isKindOfClass:[FSSettingsViewController class]]) {
            [FSProgressHUD showHUDWithText:@"Please login again" delay:2.0];
        }else {
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}


#pragma mark - <UIImagePickerControllerDelegate>

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage = [[UIImage alloc] init];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        if ([mediaType isEqualToString:@"public.image"]) {
            originalImage = info[UIImagePickerControllerEditedImage];
        }
    }
    
    WeakSelf;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *maxImage = [originalImage imageToImageMaxWidthOrHeight:600];
        NSData *imageData = UIImagePNGRepresentation(maxImage);
        [weakSelf uploadAvatarWithData:imageData];
    }];;
}



@end
