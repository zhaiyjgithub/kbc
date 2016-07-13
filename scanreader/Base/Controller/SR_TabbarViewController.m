//
//  SR_TabbarViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_TabbarViewController.h"
#import "SR_FoundMainViewController.h"
#import "SR_ScanMainViewController.h"
#import "SR_RecorMainViewController.h"

@implementation SR_TabbarViewController

- (void)viewDidLoad{
    [super view];
    [self setupAllChildViewControllers];
}

- (void)setupAllChildViewControllers{
    SR_FoundMainViewController * foundVC = [[SR_FoundMainViewController alloc] init];
    [self setupChildViewController:foundVC title:@"发现" imageName:@"icon_tabbar_01" selectImageName:@"icon_tabbar_01_h"];
    
    SR_ScanMainViewController * scanVC = [[SR_ScanMainViewController alloc] init];
    [self setupChildViewController:scanVC title:@"扫描" imageName:@"icon_tabbar_02" selectImageName:@"icon_tabbar_02_h"];
    
    SR_RecorMainViewController * recordVC = [[SR_RecorMainViewController alloc] init];
    [self setupChildViewController:recordVC title:@"记录" imageName:@"icon_tabbar_03" selectImageName:@"icon_tabbar_03_h"];
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}

@end
