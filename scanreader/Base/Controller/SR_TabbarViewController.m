//
//  SR_TabbarViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_TabbarViewController.h"
#import "SR_FoundMainViewController.h"
#import "SR_RecorMainViewController.h"
#import "DDQRCodeViewController.h"
#import "SR_ScanMainViewController.h"
#import "globalHeader.h"
#import "httpTools.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "globalHeader.h"
#import "SR_LoginViewController.h"
#import "SR_ScanViewController.h"
#import "SR_ScanImageViewController.h"

@implementation SR_TabbarViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupAllChildViewControllers];
}

- (void)setupAllChildViewControllers{
    SR_FoundMainViewController * foundVC = [[SR_FoundMainViewController alloc] init];
    [self setupChildViewController:foundVC title:@"发现" imageName:@"fx_fx_nor" selectImageName:@"fx_fx_hl"];
    
    SR_ScanImageViewController * scanVC = [[SR_ScanImageViewController alloc] init];
    [self setupChildViewController:scanVC title:@"扫描" imageName:@"jl_sm" selectImageName:@"jl_sm"];
    
    SR_RecorMainViewController * recordVC = [[SR_RecorMainViewController alloc] init];
    [self setupChildViewController:recordVC title:@"记录" imageName:@"fx_jl_nor" selectImageName:@"fx_jl_hl"];
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:baseColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15.0],NSFontAttributeName,nil] forState:(UIControlStateSelected)];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

@end
