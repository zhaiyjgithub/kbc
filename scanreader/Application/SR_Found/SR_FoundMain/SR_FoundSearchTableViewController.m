//
//  SR_FoundSearchTableViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/18.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundSearchTableViewController.h"
#import "globalHeader.h"

@interface SR_FoundSearchTableViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar * searchBar;
@end

@implementation SR_FoundSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSerchBar];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)setupSerchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 44)];
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
}


@end
