//
//  FSHttpRequests.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/11/25.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#ifndef FSHttpRequests_h
#define FSHttpRequests_h

//MARK: - 服务端口1
static  NSString *kGlobalHost = @"http://lscy5.caeac.com.cn";

#define kSetHttpUrl(url)  [NSString stringWithFormat:@"%@%@", kGlobalHost, url]

//MARK: - ------------- 用户登录 -------------
#define kUser_Login kSetHttpUrl(@"/api5.1/login.php?")

/// 用户注册
#define kUsre_Register kSetHttpUrl(@"/api5.1/register.php?")

//MARK: - ------------- 首页 -------------
/// 首页列表
#define kHome_List  kSetHttpUrl(@"/api5.1/home_newindex.php?")

/// 首页-菜单&详情
#define kHome_Option_List   kSetHttpUrl(@"/api5.1/news.php?")

/// 首页-今日热点-评论列表
#define kHome_Comment_List   kSetHttpUrl(@"/api5.1/news_pinglun_list.php?")

/// 首页-今日热点-评论
#define kHome_Comment   kSetHttpUrl(@"/api5.1/news_pinglun.php?")


//MARK: - ------------- 分类 -------------
#define kClassify_List  kSetHttpUrl(@"/api5.1/product_fenlei.php?")

/// 分类-产品-搜索
#define kClassify_Product   kSetHttpUrl(@"/api5.1/product.php?")

/// 产品-加入购物车
#define kAdd_ShoppingCart  kSetHttpUrl(@"/api5.1/ShoppingCart.php?")

/// 产品-详情-评论
#define kProduct_Comment  kSetHttpUrl(@"/api5.1/product_pinglun.php?")

/// 产品-详情-评论列表
#define kProduct_Comment_List  kSetHttpUrl(@"/api5.1/product_pinglun_list.php?")


//MARK: - ------------- 店铺 -------------
/// 店铺列表
#define kStore_List  kSetHttpUrl(@"/api5.1/newpartner.php?")

/// 店铺详情
#define kStore_Detail  kSetHttpUrl(@"/api5.1/partner.php?")

/// 店铺收藏
#define kStore_Collect  kSetHttpUrl(@"/api5.1/product_shoucang.php?")

/// 商品收藏
#define kProduct_Collect kSetHttpUrl(@"/api5.1/product_shoucang.php?")

//MARK: - ------------- 我的 -------------

/// 我的-用户基本信息
#define kUser_Info  kSetHttpUrl(@"/api5.1/user_info.php?")

/// 我的-修改用户头像
#define kUpload_Photo kSetHttpUrl(@"/api5.1/user_photo.php")

/// 我的-更新用户信息
#define KUser_Info_Update  kSetHttpUrl(@"/api5.1/user_update.php?")

/// 我的-购物车列表
#define kShopCart_List  kSetHttpUrl(@"/api5.1/ShoppingCart_list.php?")

/// 购物车商品更新
#define kShopCart_Update  kSetHttpUrl(@"/api5.1/ShoppingCart_update.php?")

/// 购物车-商品-订单确认
#define kShopCaset_Order   kSetHttpUrl(@"/api5.1/order_check.php?")

/// 购物车-商品-添加订单
#define kOrder_add  kSetHttpUrl(@"/api5.1/order_add.php?")

/// 我的订单列表
#define kOrder_List  kSetHttpUrl(@"/api5.1/order_my.php?")

/// 删除订单
#define kOrser_Delete  kSetHttpUrl(@"/api5.1/order_del.php?")

/// 我的地址列表
#define kAddress_List kSetHttpUrl(@"/api5.1/address.php?")

/// 新增收货地址
#define kAddress_Add kSetHttpUrl(@"/api5.1/address_add.php?")

/// 删除当前地址
#define kAddress_Delete kSetHttpUrl(@"/api5.1/address_del.php?")

/// 店铺收藏列表
#define kStore_CollectList  kSetHttpUrl(@"/api5.1/partner_shoucang_list.php?")

/// 商品收藏列表
#define kProduct_CollectList  kSetHttpUrl(@"/api5.1/product_shoucang_list.php?")


#endif /* FSHttpRequests_h */
