//
//  globalHeader.h
//  scanreader
//
//  Created by jbmac01 on 16/7/12.
//  Copyright © 2016年 jb. All rights reserved.
//

#ifndef globalHeader_h
#define globalHeader_h

#define TEST_SERVER  0  //1 = 测试环境 ||  0 = 正式环境



#if TEST_SERVER
///发包注意先关闭测试环境
#define BASE_URL            @"http://124.173.68.156:8180/DDCoffee/"
#else
#define BASE_URL            @"http://211.155.18.95:8180/DDCoffee/"
#endif


#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define baseColor  kColor(78,225,221)

//// 1.通过RGB的三个值获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

//// 2.定义全局的调试输出接口
#ifdef DEBUG
#define SSLog(...) NSLog(__VA_ARGS__)
#else
#define SSLog(...)
#endif

#endif /* globalHeader_h */
