//
//  URLHeader.h
//  HOOLA
//
//  Created by 犇犇网络 on 2018/9/18.
//  Copyright © 2018年 Darius. All rights reserved.
//

#ifndef URLHeader_h
#define URLHeader_h

/****线上服务器***/
#define kDomainUrl @"http://zhuang.tainongnongzi.com/"
#define kIMageUrl @"http://zhuang.tainongnongzi.com"

/****测试服务器***/
//#define kDomainUrl @"http://47.94.226.125/"
//#define kIMageUrl @"http://47.94.226.125"


#define kServerUrl [NSString stringWithFormat:@"%@api/", kDomainUrl]

/**************************通用******************************/
/**上传多张图片**/
#define kUploadImgURL [NSString stringWithFormat:@"%@common/uploadimgs", kServerUrl]
/**上传视频**/
#define kUploadVideoURL [NSString stringWithFormat:@"%@com/uploadVideo", kServerUrl]
/**上传单张图片**/
#define kImgUploadURL [NSString stringWithFormat:@"%@common/upload", kServerUrl]
/**轮播图广告图**/
#define kGetAdURL [NSString stringWithFormat:@"%@index/getAd", kServerUrl]

/**************************登录注册******************************/
/**短信注册**/
#define kRegisterURL [NSString stringWithFormat:@"%@user/register", kServerUrl]
/**短信登录**/
#define kMessageLoginURL [NSString stringWithFormat:@"%@user/mobilelogin", kServerUrl]
/**密码登录**/
#define kPasswordLoginURL [NSString stringWithFormat:@"%@user/login", kServerUrl]
/**获取验证码**/
#define kGetCodeURL [NSString stringWithFormat:@"%@sms/send", kServerUrl]
/**忘记密码**/
#define kForgetPasswordURL [NSString stringWithFormat:@"%@user/resetpwd", kServerUrl]
/**第三方登录**/
#define kDiSanFangLoginURL [NSString stringWithFormat:@"%@user/other_login", kServerUrl]

/**************************首页******************************/
/**首页**/
#define kHomeData [NSString stringWithFormat:@"%@api/index/index", kDomainUrl]
/**首页广告（banner）**/
#define kRencaiIndex [NSString stringWithFormat:@"%@/addons/recruit/api.index/index", kDomainUrl]

/**首页轮播图**/
#define kCartIndex [NSString stringWithFormat:@"%@addons/stuff/api.index/index", kDomainUrl]


/*****工地考勤*****/
/**工地考勤首页**/
#define kGongDiKaoQinHome [NSString stringWithFormat:@"%@addons/clockin/api.index/index", kDomainUrl]
/**建群**/
#define kFoundGroup [NSString stringWithFormat:@"%@addons/clockin/api.index/found_group", kDomainUrl]
/**工种**/
#define kWorkList [NSString stringWithFormat:@"%@addons/clockin/api.index/worklist", kDomainUrl]
/**建打卡群所需积分**/
#define kFoundGroupCleck [NSString stringWithFormat:@"%@addons/clockin/api.index/found_group_cleck", kDomainUrl]
/**群成员列表**/
#define kGroupUserList [NSString stringWithFormat:@"%@addons/clockin/api.index/group_user_list", kDomainUrl]

/**退出群、解散群、删除群**/
#define kExitGroup [NSString stringWithFormat:@"%@addons/clockin/api.index/exit_group", kDomainUrl]
/**添加群成员**/
#define kAddGroupUser [NSString stringWithFormat:@"%@addons/clockin/api.index/add_group_user", kDomainUrl]

/**设置群成员信息**/
#define kSetUserInfo [NSString stringWithFormat:@"%@addons/clockin/api.index/set_user_info", kDomainUrl]

/** 查看群成员信息**/
#define kGetUserInfo [NSString stringWithFormat:@"%@addons/clockin/api.index/get_user_info", kDomainUrl]
/** 查看群打卡规则**/
#define kGetGroupRule [NSString stringWithFormat:@"%@addons/clockin/api.index/get_group_rule", kDomainUrl]
/** 设置群打卡规则**/
#define kSetGroupRule [NSString stringWithFormat:@"%@addons/clockin/api.index/set_group_rule", kDomainUrl]

/** 月打卡详情**/
#define kMonthCount [NSString stringWithFormat:@"%@addons/clockin/api.Count/month_count", kDomainUrl]

/** 按天统计**/
#define kGetDateClockin [NSString stringWithFormat:@"%@addons/clockin/api.count/get_date_clockin", kDomainUrl]
/** 打卡月历**/
#define kClockinCount [NSString stringWithFormat:@"%@addons/clockin/api.count/clockin_count", kDomainUrl]

/**  申诉**/
#define kAbnormalAppeal [NSString stringWithFormat:@"%@addons/clockin/api.count/abnormal_appeal", kDomainUrl]
/** 获取当前打卡群的列表**/
#define kGetClockinGroup [NSString stringWithFormat:@"%@addons/clockin/api.punchin/get_clockin_group", kDomainUrl]
/** 打卡**/
#define kClockIn [NSString stringWithFormat:@"%@addons/clockin/api.punchin/clock_in", kDomainUrl]

/** 自动打卡（修改）**/
#define kAutoClockin [NSString stringWithFormat:@"%@addons/clockin/api.punchin/auto_clockin", kDomainUrl]
/**打卡群列表**/
#define kGroupList [NSString stringWithFormat:@"%@addons/clockin/api.index/group_list", kDomainUrl]

/**审核**/
#define kAdminApply [NSString stringWithFormat:@"%@addons/clockin/api.count/admin_apply", kDomainUrl]
/**异常审核列表**/
#define kAbnormalAppealList [NSString stringWithFormat:@"%@addons/clockin/api.count/abnormal_appeal_list", kDomainUrl]

/**搜索人员**/
#define kGetUser [NSString stringWithFormat:@"%@addons/clockin/api.index/get_user", kDomainUrl]
/*****工地找工人*****/
/**工地找工人列表**/
#define kRecruitList [NSString stringWithFormat:@"%@addons/recruit/api.index/recruitList", kDomainUrl]
/**我的发布记录**/
#define kmyRelease [NSString stringWithFormat:@"%@addons/recruit/api.index/myRelease", kDomainUrl]
/**发布招工信息**/
#define kRecruitMan [NSString stringWithFormat:@"%@addons/recruit/api.index/recruitMan", kDomainUrl]
/**查询籍贯，上岗时间，日工作时间，结算时间**/
#define kArrayRecruit [NSString stringWithFormat:@"%@addons/recruit/api.index/arrayRecruit", kDomainUrl]
/**我的发布记录**/
#define kmyRelease [NSString stringWithFormat:@"%@addons/recruit/api.index/myRelease", kDomainUrl]
/**发布招工信息**/
#define kRecruitMan [NSString stringWithFormat:@"%@addons/recruit/api.index/recruitMan", kDomainUrl]
/**编辑**/
#define kEditRecruitMan [NSString stringWithFormat:@"%@addons/recruit/api.index/edit_recruitMan", kDomainUrl]
/**下架我的发布**/
#define kLowerRecruit [NSString stringWithFormat:@"%@addons/recruit/api.index/lowerRecruit", kDomainUrl]
/**删除我的发布**/
#define kDeleteRecruit [NSString stringWithFormat:@"%@addons/recruit/api.index/deleteRecruit", kDomainUrl]
/**岗位详情**/
#define kWorkInfo [NSString stringWithFormat:@"%@addons/recruit/api.index/workInfo", kDomainUrl]
/**关注与取消关注（服务）**/
#define kAddServerFollow [NSString stringWithFormat:@"%@addons/stuff/api.follow/add_server_follow", kDomainUrl]
/**使用福利券（修改））**/
#define kUseWelfare [NSString stringWithFormat:@"%@addons/recruit/api.welfare/use_welfare", kDomainUrl]

/**置顶**/
#define kGongDiFindTopRefresha [NSString stringWithFormat:@"%@addons/recruit/api.Index/top_refresh", kDomainUrl]
/**刷新简历**/
#define kGongDiFindjianliRefresh [NSString stringWithFormat:@"%@addons/recruit/api.Index/refresh", kDomainUrl]

/*****工人找工作*****/
/**工人找工作列表**/
#define kGongRenFindWorkList [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/findJob", kDomainUrl]
/**工人找工作我的发布记录列表**/
#define kMyFaBuJiLuList [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/myRelease", kDomainUrl]
/**工人找工作下架**/
#define kMyFaBuXiaJia [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/lowerRecruit", kDomainUrl]
/**工人找工作删除**/
#define kMyFaBuDelete [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/deleteRecruit", kDomainUrl]
/**工人找工作发布简历**/
#define kFindWorkAddJob [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/addJob", kDomainUrl]
/**置顶**/
#define kFindWorkTopRefresha [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/top_refresh", kDomainUrl]
/** 编辑求职简历**/
#define kEditAddJob [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/edit_addJob", kDomainUrl]
/**简历详情**/
#define kjianliDetail [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/jobInfo", kDomainUrl]
/**刷新简历**/
#define kjianliRefresh [NSString stringWithFormat:@"%@addons/recruit/api.Findwork/refresh", kDomainUrl]

/*****员工求职*****/
/**求职列表**/
#define kYuanGongQiuZhiList [NSString stringWithFormat:@"%@addons/recruit/api.Job/findJob", kDomainUrl]
/**我的发布记录列表**/
#define kQZMyFaBuJiLuList [NSString stringWithFormat:@"%@addons/recruit/api.Job/myRelease", kDomainUrl]
/**删除**/
#define kQZMyFaBuDelete [NSString stringWithFormat:@"%@addons/recruit/api.Job/deleteRecruit", kDomainUrl]
/**下架**/
#define kQZMyFaBuXiaJia [NSString stringWithFormat:@"%@addons/recruit/api.Job/lowerRecruit", kDomainUrl]

/**置顶我的求职信息**/
#define kTopRefresha [NSString stringWithFormat:@"%@addons/recruit/api.job/top_refresh", kDomainUrl]
/**刷新**/
#define kQZjianliRefresh [NSString stringWithFormat:@"%@addons/recruit/api.Job/refresh", kDomainUrl]
/**发布**/
#define kQZFaBu [NSString stringWithFormat:@"%@addons/recruit/api.Job/addJob", kDomainUrl]
/**编辑**/
#define kQZFaBuEdit [NSString stringWithFormat:@"%@addons/recruit/api.job/editJob", kDomainUrl]
/**岗位数据**/
#define kGetGangweiData [NSString stringWithFormat:@"%@addons/recruit/api.Company/education", kDomainUrl]

/**求职详情**/
#define kQiuziJobInfo [NSString stringWithFormat:@"%@addons/recruit/api.job/jobInfo", kDomainUrl]
/*********企业招聘*********/

/****招聘详情****/
#define kQiyeWorkInfo [NSString stringWithFormat:@"%@addons/recruit/api.Company/workInfo", kDomainUrl]
/****我的发布记录****/
#define kQiyeMyRelease [NSString stringWithFormat:@"%@addons/recruit/api.Company/myRelease", kDomainUrl]
/****查询出招聘岗位****/
#define kQiyeEducatione [NSString stringWithFormat:@"%@addons/recruit/api.Company/education", kDomainUrl]
/****区域查询****/
#define kGetQuYuList [NSString stringWithFormat:@"%@addons/stuff/api.Area/area_list", kDomainUrl]
/****查询验证码是否正确****/
#define kQiyeCheckMobile [NSString stringWithFormat:@"%@addons/recruit/api.Company/checkMobile", kDomainUrl]
/**** 企业招聘列表****/
#define kQiyeRecruitList [NSString stringWithFormat:@"%@addons/recruit/api.Company/recruitList", kDomainUrl]
/**刷新我的招聘信息**/
#define kQiyeRefresh [NSString stringWithFormat:@"%@addons/recruit/api.Company/refresh", kDomainUrl]
/**企业发布招聘**/
#define kQiyeRecruitMan [NSString stringWithFormat:@"%@addons/recruit/api.Company/recruitMan", kDomainUrl]
/**企业编辑招聘**/
#define kQiyeZhaoPinEdit [NSString stringWithFormat:@"%@addons/recruit/api.Company/edit_recruitMan", kDomainUrl]
/**上下架我的发布**/
#define kQiyeLowerRecruit [NSString stringWithFormat:@"%@addons/recruit/api.Company/lowerRecruit", kDomainUrl]
/**置顶我的发布**/
#define kQiyeTopRefresh [NSString stringWithFormat:@"%@addons/recruit/api.Company/top_refresh", kDomainUrl]
/**判断是否实名认证**/
#define kCheckIdauth [NSString stringWithFormat:@"%@addons/recruit/api.index/checkIdauth", kDomainUrl]
/**材料分类**/
#define kGetCategory [NSString stringWithFormat:@"%@addons/stuff/api.stuff/get_category", kDomainUrl]
/**材料列表**/
#define kGetStuffList [NSString stringWithFormat:@"%@addons/stuff/api.stuff/get_stuff_list", kDomainUrl]
//自定义材料分类
#define kApplyCategory [NSString stringWithFormat:@"%@addons/stuff/api.stuff/apply_category", kDomainUrl]
/**材料关联材料**/
#define kGetStuffRelation [NSString stringWithFormat:@"%@addons/stuff/api.stuff/get_stuff_relation", kDomainUrl]
//自定义品牌
#define kGetapplyBrand [NSString stringWithFormat:@"%@addons/stuff/api.stuff/apply_brand", kDomainUrl]
//自定义材料
#define kApplyStuff [NSString stringWithFormat:@"%@addons/stuff/api.stuff/apply_stuff", kDomainUrl]
//保存材料单
#define kAddStuffCart [NSString stringWithFormat:@"%@addons/stuff/api.stuff/add_stuff_cart", kDomainUrl]
/**项目分类**/
#define kGetProject [NSString stringWithFormat:@"%@addons/stuff/api.project/get_project", kDomainUrl]
/**项目下材料列表**/
#define kGetProjectList [NSString stringWithFormat:@"%@addons/stuff/api.project/get_stuff_list", kDomainUrl]

/**********工程服务********/
/**工程服务首页**/
#define kGongChengFuWuHome [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/CategoryList", kDomainUrl]
/**工程服务列表**/
#define kGetRecruitList [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/recruitList", kDomainUrl]
/**我的发布记录**/
#define kFuwuMyRelease [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/myRelease",kDomainUrl]
/**工程服务详情**/
#define kFuwuWorkInfo [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/workInfo",kDomainUrl]

/**相关法律，验收标准，施工**/
#define kRuleCentor [NSString stringWithFormat:@"%@addons/stuff/api.seller/rule_centor",kDomainUrl]
/**刷新工程服务**/
#define kFuwuRefresh [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/refresh", kDomainUrl]
/**服务类型列表**/
#define kEngineeringCategory [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/engineeringCategory", kDomainUrl]
/**发布工程服务**/
#define kEnginRecruitMan [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/recruitMan", kDomainUrl]
/**编辑**/
#define kEditMyRelease [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/edit_myRelease", kDomainUrl]
/**删除**/
#define kGCMyFaBuDelete [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/deleteRecruit", kDomainUrl]
/**下架**/
#define kGCMyFaBuXiaJia [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/lowerRecruit", kDomainUrl]
/**刷新**/
#define kGCjianliRefresh [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/refresh", kDomainUrl]
/**置顶工程服务（修改）**/
#define kGCjianliTopRefresh [NSString stringWithFormat:@"%@addons/recruit/api.Engineering/top_refresh", kDomainUrl]
/********************************商城页面*******************************************/
/**商城首页**/
#define kLitestoreIndex [NSString stringWithFormat:@"%@addons/litestore/api.index/index", kDomainUrl]
/**我的搜索历史**/
#define kMySearchHistory [NSString stringWithFormat:@"%@addons/stuff/api.store/my_search_history", kDomainUrl]

/** 删除搜索历史**/
#define kDelGoodsVisitHistory [NSString stringWithFormat:@"%@addons/stuff/api.user/del_goods_visit_history", kDomainUrl]
/**搜索商品**/
#define kSearchStore [NSString stringWithFormat:@"%@addons/stuff/api.store/search_store", kDomainUrl]
/**热门搜索词**/
#define kHotWord [NSString stringWithFormat:@"%@/addons/stuff/api.store/hot_word", kDomainUrl]
/***商城首页店铺列表*/
#define kIndexStoreList [NSString stringWithFormat:@"%@addons/stuff/api.store/index_store_list", kDomainUrl]
/***店铺商品查询*/
#define kCategoryGoods [NSString stringWithFormat:@"%@addons/litestore/api.sellerDetails/categoryGoods", kDomainUrl]
/****添加购物车****/
#define kAddCart [NSString stringWithFormat:@"%@addons/litestore/api.cart/add", kDomainUrl]

/****立即购买(结算)****/
#define kBuyNow [NSString stringWithFormat:@"%@addons/litestore/api.order/buyNow", kDomainUrl]
/****评论列表****/
#define kEvaluSelect [NSString stringWithFormat:@"%@addons/litestore/api.evaluate/evalu_select", kDomainUrl]
/****商品详情****/
#define kGoodsDetail [NSString stringWithFormat:@"%@addons/litestore/api.goods/detail", kDomainUrl]
/****减少购物车商品数量****/
#define kSubCart [NSString stringWithFormat:@"%@addons/litestore/api.cart/sub", kDomainUrl]
/****增加购物车商品数量****/
#define kAddnumCart [NSString stringWithFormat:@"%@addons/litestore/api.cart/addnum", kDomainUrl]
/***店铺详情*/
#define kSellerDetails [NSString stringWithFormat:@"%@addons/litestore/api.sellerDetails/sellerDetails", kDomainUrl]

/***店铺添加关注***/
#define kDianpuFollow [NSString stringWithFormat:@"%@addons/litestore/api.follow/add", kDomainUrl]

/***取消关注***/
#define kCancelFollow [NSString stringWithFormat:@"%@addons/litestore/api.follow/cancel_follow", kDomainUrl]
/***店铺导入材料车***/
#define kImportOrder [NSString stringWithFormat:@"%@addons/stuff/api.stufforder/import_order", kDomainUrl]
/***自动计算项目列表*/
#define kGetProjectAuto [NSString stringWithFormat:@"%@addons/stuff/api.project/get_project_auto", kDomainUrl]

/**************************材料车******************************/
/****材料车列表****/
#define kGetcartLists [NSString stringWithFormat:@"%@addons/stuff/api.stuff/get_cart_lists", kDomainUrl]
/**** 删除购物车****/
#define kGoodsDelete [NSString stringWithFormat:@"%@addons/litestore/api.cart/delete", kDomainUrl]
/**** 购物车列表****/
#define kGetlists [NSString stringWithFormat:@"%@addons/litestore/api.cart/getlists", kDomainUrl]

/****重命名材料单名****/
#define kUpdateCartname [NSString stringWithFormat:@"%@addons/stuff/api.stuff/update_cartname", kDomainUrl]
/****商城预估总价（新增）****/
#define kGerPrices [NSString stringWithFormat:@"%@addons/stuff/api.stuff/ger_prices", kDomainUrl]
/****分享材料单****/
#define kStuffShare [NSString stringWithFormat:@"%@addons/stuff/api.stuff/share", kDomainUrl]
/****发布材料单****/
#define kRelease [NSString stringWithFormat:@"%@addons/stuff/api.purchase/release", kDomainUrl]
/**** 检查材料单数据（预合并****/
#define kCheckCart [NSString stringWithFormat:@"%@addons/stuff/api.stuff/check_cart", kDomainUrl]
/****删除所选材料单****/
#define kDeleteCart [NSString stringWithFormat:@"%@addons/stuff/api.stuff/delete_cart", kDomainUrl]
/****材料单详情****/
#define kGetcartDetail [NSString stringWithFormat:@"%@addons/stuff/api.stuff/get_cart_detail", kDomainUrl]

/****品牌列表****/
#define kBrandList [NSString stringWithFormat:@"%@addons/stuff/api.stuff/brand_list", kDomainUrl]
/****重新编辑材料单****/
#define kUpdateCart [NSString stringWithFormat:@"%@addons/stuff/api.stuff/update_cart", kDomainUrl]
/**** 合并材料单****/
#define kMergeCart [NSString stringWithFormat:@"%@addons/stuff/api.stuff/merge_cart", kDomainUrl]

/**************************我的******************************/
/****个人信息****/
#define kMyIndex [NSString stringWithFormat:@"%@user/index", kServerUrl]

/****我的发布****/
#define kMyServerList [NSString stringWithFormat:@"%@addons/stuff/api.user/my_server_list", kDomainUrl]

/****修改支付密码****/
#define kEditPayPassword [NSString stringWithFormat:@"%@addons/stuff/api.user/edit_pay_password", kDomainUrl]
/****通过原密码 修改密码****/
#define kChangepwd [NSString stringWithFormat:@"%@user/changepwd", kServerUrl]
/****修改昵称头像****/
#define kEditUser [NSString stringWithFormat:@"%@addons/stuff/api.user/edit_user", kDomainUrl]
/****我的钱包****/
#define kMyWallet [NSString stringWithFormat:@"%@user/my_wallet", kServerUrl]
/****充值****/
#define kSubmit [NSString stringWithFormat:@"%@addons/recharge/api.recharge/submit", kDomainUrl]
/****余额购买超级会员****/
#define kBugSuperHuiYuan [NSString stringWithFormat:@"%@addons/recharge/api.recharge/balance_get_level", kDomainUrl]
/**** 查看提现进度****/
#define kNearRecharge [NSString stringWithFormat:@"%@addons/stuff/api.pred/near_recharge", kDomainUrl]
/****购买会员详情****/
#define kBuyLevelDetail [NSString stringWithFormat:@"%@addons/stuff/api.user/buy_level_befor", kDomainUrl]
/****积分购买会员****/
#define kCoinGetLevel [NSString stringWithFormat:@"%@addons/recharge/api.recharge/coin_get_level", kDomainUrl]
/****绑定微信支付宝****/
#define kSetAliWechat [NSString stringWithFormat:@"%@addons/stuff/api.seller/set_ali_wechat", kDomainUrl]
/****用户预提现****/
#define kAccountInfo [NSString stringWithFormat:@"%@addons/stuff/api.user/account_info", kDomainUrl]
/****提现申请****/
#define kAddCash [NSString stringWithFormat:@"%@addons/stuff/api.pred/add_cash", kDomainUrl]
/****关注列表****/
#define kFollowList [NSString stringWithFormat:@"%@addons/litestore/api.follow/follow_list", kDomainUrl]
/****批量删除关注****/
#define kDeleteFollowMore [NSString stringWithFormat:@"%@addons/stuff/api.follow/delete_follow_more", kDomainUrl]
/****我关注的服务****/
#define kMyFollowServer [NSString stringWithFormat:@"%@addons/stuff/api.follow/my_follow_server", kDomainUrl]
/****删除关注（服务)****/
#define kDeleteServerFollow [NSString stringWithFormat:@"%@addons/stuff/api.follow/delete_server_follow", kDomainUrl]
/****店铺足迹****/
#define kStoreZuJiList [NSString stringWithFormat:@"%@addons/stuff/api.visit/my_visit_list", kDomainUrl]
/**** 服务足迹列表****/
#define kServerVisitList [NSString stringWithFormat:@"%@/addons/stuff/api.visit/server_visit_list", kDomainUrl]
/****商品足迹列表****/
#define kGoodsVisitList [NSString stringWithFormat:@"%@addons/stuff/api.visit/goods_visit_list", kDomainUrl]
/****删除足迹****/
#define kDeleteVisit [NSString stringWithFormat:@"%@addons/stuff/api.visit/delete_visit", kDomainUrl]

/****删除服务足迹****/
#define kDelServerVisit [NSString stringWithFormat:@"%@addons/stuff/api.visit/del_server_visit", kDomainUrl]

/****添加+修改企业认证****/
#define kAddEnterpriseAuth [NSString stringWithFormat:@"%@addons/stuff/api.authen/add_enterprise_auth", kDomainUrl]
/****企业认证详情****/
#define kMyEnterpriseAuth [NSString stringWithFormat:@"%@addons/stuff/api.authen/my_enterprise_auth", kDomainUrl]
/****修改我的发票****/
#define kEditInvoice [NSString stringWithFormat:@"%@addons/stuff/api.authen/edit_invoice", kDomainUrl]
/****查看我的发票****/
#define kMyInvoice [NSString stringWithFormat:@"%@addons/stuff/api.authen/my_invoice", kDomainUrl]
/****添加修改申请****/
#define kAddAgentApply [NSString stringWithFormat:@"%@addons/stuff/api.authen/add_agent_apply", kDomainUrl]

/****行业列表****/
#define kIndustryList [NSString stringWithFormat:@"%@addons/stuff/api.index/industry_list", kDomainUrl]
/****商家入驻二维码****/
#define kStoreQCode [NSString stringWithFormat:@"%@addons/qrcode/code/get_code", kDomainUrl]
/****人工服务****/
#define kUserServer [NSString stringWithFormat:@"%@addons/stuff/api.index/user_server", kDomainUrl]
/****文章详情****/
#define kArticleInfo [NSString stringWithFormat:@"%@addons/stuff/api.seller/article_info", kDomainUrl]
/****添加修改工长认证****/
#define kAddForemanAuth [NSString stringWithFormat:@"%@addons/stuff/api.authen/add_foreman_auth", kDomainUrl]
/****修改手机号****/
#define kChangeMobile [NSString stringWithFormat:@"%@addons/stuff/api.user/change_mobile", kDomainUrl]
/****工长认证结果****/
#define kMyForemanAuth [NSString stringWithFormat:@"%@addons/stuff/api.authen/my_foreman_auth", kDomainUrl]
/****经营类型****/
#define kManagementType [NSString stringWithFormat:@"%@addons/stuff/api.index/management_type", kDomainUrl]
/****判断是否实名认证****/
#define kShimingCheckIdauth [NSString stringWithFormat:@"%@addons/stuff/api.authen/my_auth", kDomainUrl]
/****判断是否企业认证****/
#define kQiyeCheckIdauth [NSString stringWithFormat:@"%@addons/recruit/api.Company/checkIdauth", kDomainUrl]
/****添加，修改实名认证****/
#define kAddAuth [NSString stringWithFormat:@"%@addons/stuff/api.authen/add_auth", kDomainUrl]
/****我的订单列表****/
#define kmyOrderList [NSString stringWithFormat:@"%@addons/litestore/api.order/my", kDomainUrl]
/****评价订单商品****/
#define kEvaluGoods [NSString stringWithFormat:@"%@addons/litestore/api.evaluate/evalu_goods", kDomainUrl]
/****用户收货/收货异常****/
#define kReceivGoods [NSString stringWithFormat:@"%@addons/stuff/api.stufforder/receivGoods", kDomainUrl]

/****催单（修改最新）****/
#define kReminder [NSString stringWithFormat:@"%@addons/litestore/api.order/reminder", kDomainUrl]
/****异常订单详情****/
#define kAbnormalOrder [NSString stringWithFormat:@"%@addons/litestore/api.order/abnormalOrder", kDomainUrl]
/****申诉（修改）****/
#define kAddAppeal [NSString stringWithFormat:@"%@addons/stuff/api.user/add_appeal", kDomainUrl]
/****评价订单****/
#define kEvaluOrder [NSString stringWithFormat:@"%@addons/litestore/api.evaluate/evalu_order", kDomainUrl]
/****取消订单****/
#define kCancelOrder [NSString stringWithFormat:@"%@addons/stuff/api.stufforder/cancelOrder", kDomainUrl]

/****删除订单****/
#define kDelOrder [NSString stringWithFormat:@"%@addons/litestore/api.order/del_order", kDomainUrl]
/****查看我的发票****/
#define kMyInvoice [NSString stringWithFormat:@"%@addons/stuff/api.authen/my_invoice", kDomainUrl]
/****订单详情****/
#define kOrderDetail [NSString stringWithFormat:@"%@addons/litestore/api.order/detail", kDomainUrl]
/****我的报价单列表****/
#define kReceiptList [NSString stringWithFormat:@"%@addons/stuff/api.purchase/receiptList", kDomainUrl]
/****报价单详情****/
#define kReceiptDetail [NSString stringWithFormat:@"%@addons/stuff/api.purchase/receipt", kDomainUrl]
/****收货地址列表****/
#define kAddressLists [NSString stringWithFormat:@"%@addons/litestore/api.adress/lists", kDomainUrl]

/****查询订单 运费 （修改）****/
#define kFreight [NSString stringWithFormat:@"%@addons/stuff/api.stufforder/freight", kDomainUrl]
/****购物车结算****/
#define kCartGetinfo [NSString stringWithFormat:@"%@addons/litestore/api.cart/getinfo", kDomainUrl]
/****可用优惠券****/
#define kCartCoupons [NSString stringWithFormat:@"%@addons/litestore/api.order/coupons", kDomainUrl]
/****报价单详情****/
#define kDemolitionOrder [NSString stringWithFormat:@"%@addons/stuff/api.stufforder/demolition_order", kDomainUrl]
/****添加收货地址****/
#define kAddressAdd [NSString stringWithFormat:@"%@addons/litestore/api.adress/add", kDomainUrl]
/***可用优惠券****/
#define kCoupon [NSString stringWithFormat:@"%@addons/litestore/api.order/coupon", kDomainUrl]
/***添加材料单订单****/
#define kAddOrder [NSString stringWithFormat:@"%@addons/stuff/api.stufforder/addOrder", kDomainUrl]
/***店铺发票类型****/
#define kInvoice [NSString stringWithFormat:@"%@addons/litestore/api.sellerdetails/invoice", kDomainUrl]
/***剩余积分****/
#define kIntegral [NSString stringWithFormat:@"%@addons/litestore/api.order/integral", kDomainUrl]
#define kSAddressDel [NSString stringWithFormat:@"%@addons/litestore/api.adress/del", kDomainUrl]
/*** 店铺积分使用规则查询****/
#define kScorerul [NSString stringWithFormat:@"%@addons/stuff/api.stufforder/scorerul", kDomainUrl]




/***设置为默认收货地址****/
#define kSetdefault [NSString stringWithFormat:@"%@addons/litestore/api.adress/setdefault", kDomainUrl]
/***材料单订单支付****/
#define kOrderPay [NSString stringWithFormat:@"%@addons/stuff/api.stufforder/orderPay", kDomainUrl]
/***购物车结算****/
#define kCartPay [NSString stringWithFormat:@"%@addons/litestore/api.order/cart_pay", kDomainUrl]

/***********************积分商城***************************/
/***积分商品分类****/
#define kCategoryList [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/category_list", kDomainUrl]
/***积分商品列表****/
#define kGoodsList [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/goods_list", kDomainUrl]

/***积分日志****/
#define kCoinLogList [NSString stringWithFormat:@"%@addons/stuff/api.seller/coin_log_list", kDomainUrl]
/***积分商品详情****/
#define kGoodsDetails [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/goods_details", kDomainUrl]
/***积分兑换****/
#define kExchange [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/exchange", kDomainUrl]
/***积分订单列表****/
#define kJiFenOrderList [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/order_list", kDomainUrl]
/***积分订单详情****/
#define kJiFenOrderDetails [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/order_details", kDomainUrl]
/***积分取消订单****/
#define kJiFenCancelOrder [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/cancel_order", kDomainUrl]
/***积分确认收货****/
#define kJiFenReceivingGoodsr [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/receiving_goods", kDomainUrl]
/***积分商城支付****/
#define kJiFenPay [NSString stringWithFormat:@"%@addons/litestore/api.Integralshop/pay", kDomainUrl]

/**********************消息***************************/
/***消息首页****/
#define kXiaoXiHome [NSString stringWithFormat:@"%@api/news/news_list", kDomainUrl]
/***群详情****/
#define kGroupDetails [NSString stringWithFormat:@"%@api/news/group_details", kDomainUrl]
/***消息首页详情****/
#define kXiaoXiHomeDetail [NSString stringWithFormat:@"%@api/news/news_detail", kDomainUrl]

/***删除好友****/
#define kFriendDel [NSString stringWithFormat:@"%@api/news/friend_del", kDomainUrl]

/*** 购物车总数****/
#define kGetTotalNum [NSString stringWithFormat:@"%@addons/litestore/api.cart/getTotalNum", kDomainUrl]
/***好友列表****/
#define kFriendsList [NSString stringWithFormat:@"%@api/news/friend_list", kDomainUrl]
/***搜索好友****/
#define kSearchFriend [NSString stringWithFormat:@"%@addons/clockin/api.index/get_user", kDomainUrl]
/***好友申请****/
#define kApplyFriend [NSString stringWithFormat:@"%@api/news/friends_apply", kDomainUrl]
/*** 扫码进群***/
#define kApplyAddGroups [NSString stringWithFormat:@"%@addons/clockin/api.index/add_groups", kDomainUrl]
/***好友申请列表****/
#define kApplyFriendList [NSString stringWithFormat:@"%@api/news/apply_list", kDomainUrl]
/***申请详情****/
#define kApplyFriendDetail [NSString stringWithFormat:@"%@api/news/apply_detail", kDomainUrl]
/***通过申请****/
#define kReceiveFriend [NSString stringWithFormat:@"%@api/news/apply_examine", kDomainUrl]
/***群组列表****/
#define kXXGroupList [NSString stringWithFormat:@"%@api/news/group_list", kDomainUrl]
/***设置群状态（修改）****/
#define kSetGroupStatus [NSString stringWithFormat:@"%@addons/clockin/api.index/set_group_status", kDomainUrl]
/***群成员列表****/
#define kXXGroupUserList [NSString stringWithFormat:@"%@api/news/group_user_list", kDomainUrl]
/***群成员列表****/
#define kXXGroupUserList [NSString stringWithFormat:@"%@api/news/group_user_list", kDomainUrl]
/***添加群成员****/
#define kXXAddGroupUser [NSString stringWithFormat:@"%@api/news/add_group_user", kDomainUrl]
/***管理群****/
#define kXXManagerGroup [NSString stringWithFormat:@"%@api/news/exit_group", kDomainUrl]
/***创建群群****/
#define kXXCreateGroup [NSString stringWithFormat:@"%@api/news/create_group", kDomainUrl]
/***好友详情****/
#define kFriendDetails [NSString stringWithFormat:@"%@api/news/friend_details", kDomainUrl]
/***通讯录匹配****/
#define kContactPipei [NSString stringWithFormat:@"%@api/news/mail_list", kDomainUrl]

//微信支付
#define ORDER_PAY_NOTIFICATION  @"orderPAyNotification"

/**********************分享***************************/
/***分享商品****/
#define kShareGoods [NSString stringWithFormat:@"%@share/index/goods", kDomainUrl]
/***分享工程服务****/
#define kShareProject [NSString stringWithFormat:@"%@share/index/project", kDomainUrl]
/***分享工地招聘岗位****/
#define kShareGangwei [NSString stringWithFormat:@"%@share/gdrecruit/gangwei", kDomainUrl]
/*** 分享工地求职****/
#define kShareQiuzhi [NSString stringWithFormat:@"%@share/gdrecruit/qiuzhi", kDomainUrl]
/*** 分享企业招聘****/
#define kShareQYGangwei [NSString stringWithFormat:@"%@share/qyrecruit/gangwei", kDomainUrl]
/*** 分享企业求职****/
#define kShareQYQiuzhi [NSString stringWithFormat:@"%@share/qyrecruit/qiuzhi", kDomainUrl]

/***分享app注册****/
#define kShareRegister [NSString stringWithFormat:@"%@share/register/index", kDomainUrl]


#endif /* URLHeader_h */

