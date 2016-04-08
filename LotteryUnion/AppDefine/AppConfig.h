

/*---------------------app的相关配置---------------------*/



/*---------------------用户相关信息-----------------------*/




/*---------------------程序相关常量-----------------------*/
//App Id、下载地址、评价地址
#define kAppId      @""
#define kAppUrl     [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ling-hao-xian/id%@?ls=1&mt=8",kAppId]
#define kRateUrl    [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppId]


/*--------------------程序全局通知--------------------*/
// 选号时候震动
#define pk_vibrate_when_choose_number @"vibrate_when_choose_number"
// 充值提示与限额
#define pk_recharge_note @"recharge_note"
#define pk_recharge_limit @"recharge_limit"
// 提现提示与限额
#define pk_cashout_note @"cashout_note"
#define pk_cashout_limit @"cashout_limit"
// 分享推荐内容
#define pk_share_recommend @"share_recommend"
#define pk_release_note @"release_note"
#define pk_hide_lotteries @"hide_lotteries"
// 登录失败计数
#define pk_login_error_times @"login_error_times"
#define pk_last_login_error_time @"last_login_error_time"

#define NotifyUserInfoRefreshed @"NotifyUserInfoRefreshed"
#define NotifyLoginStatusChange @"NotifyLoginStatusChange"
#define NotifyHallSettingChanged @"NotifyHallSettingChanged"
#define NotifyReloadXyscPeriod @"NotifyReloadXyscPeriod"
#define NotifyBetConfirmSafari @"NotifyBetConfirmSafari"


/*----------------程序界面配置信息--------------*/
//设置应用的页面背景色
#define kAppBgColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
//导航控制器颜色
#define NaviBarTinColor [UIColor colorWithRed:245/255.0  green:245/255.0  blue:245/255.0 alpha:1]
//通用字体颜色
#define NAVITITLECOLOR   [UIColor darkGrayColor] //黑色字体
#define REDFONTCOLOR     toPCcolor(@"c12b1c") //红色字体
#define BLUEFONTCOLOR    toPCcolor(@"1a87cb") //蓝色字体
#define DIVLINECOLOR     toPCcolor(@"e0e0e0") //分割线颜色
#define BLACKFONTCOLOR1  [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]
#define BLUEBALLCOLOR   [UIColor colorWithRed:73/255.0 green:122/255.0 blue:250/255.0 alpha:1]

//系统字体
#define UIFONT_SC_MEDIUM(fontSize)    [UIFont fontWithName:@"STHeitiSC-Medium" size:fontSize]


//球上的字体
#define BallFont [UIFont systemFontOfSize:14]

//按钮的高度
#define ButtonHeight 35

//返回图片
#define kkBackImage  @"arrow01"
#define kkRightImage  @"jczq_no.png"



//TableView相关设置
//设置TableView分割线颜色
#define kSeparatorColor   [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]
//设置TableView背景色
#define kTableViewBgColor [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]
//设置TableView选中背景,自行根据需要更改里面函数
UIKIT_STATIC_INLINE UIView *selectedBgView(CGRect rect)
{
    UIView *selectedBgView = [[UIView alloc] initWithFrame:rect];
    [selectedBgView setBackgroundColor:[UIColor colorWithRed:60/255. green:180/255. blue:255/255. alpha:0.5]];
    return selectedBgView;
}



