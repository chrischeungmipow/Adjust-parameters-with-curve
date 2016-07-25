//
//  GlobalTool.h
//

#ifndef PABank2_Global_h
#define PABank2_Global_h

#define kSystemVesion [[[UIDevice currentDevice] systemVersion] floatValue]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
/*================================================================================================*/

#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height          //包含状态bar的高度(e.g. 480)

#define kApplicationSize      [[UIScreen mainScreen] applicationFrame].size       //(e.g. 320,460)
#define kApplicationWidth     [[UIScreen mainScreen] applicationFrame].size.width //(e.g. 320)
#define kApplicationHeight    [[UIScreen mainScreen] applicationFrame].size.height//不包含状态bar的高度(e.g. 460)

#define kStatusBarHeight      20
#define kNavigationBarHeight  44

#define kContentHeight        (kScreenHeight - kNavigationBarHeight -kStatusBarHeight)

#define kUnderStatusBarStartY (kSystemVesion>=7.0 ? 20 : 0) //7.0以上stautsbar不占位置，内容视图的起始位置要往下20

#define kContentStartY        (kSystemVesion>=7.0 ? 64 : 0) //7.0以上stautsbar，navbar不占位置，内容视图的起始位置要往下64
#define kKeyBoardHeight 216

#define kScale  (CGRectGetWidth([UIScreen mainScreen].bounds)/320.0)

#define kStatus_Height (44 + (kSystemVesion > 7.0) ? 20.0 : 0.0)
#define kStartY (kStatusBarHeight + kScreenHeight) / 2.0 //kStatusBarHeight +
#define kSpace (kScreenWidth / (kNumCount - 1))
#define kNumCount 7

#define IMAGE_NAME @"PAKeyboard.bundle"
#define IMAGE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: IMAGE_NAME]
#define PAKeyBoard_Bundle [NSBundle bundleWithPath: IMAGE_PATH]


#endif
