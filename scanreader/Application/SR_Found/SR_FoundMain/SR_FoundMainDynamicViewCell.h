//
//  SR_FoundMainDynamicViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_BookClubBookModel.h"
@interface SR_FoundMainDynamicViewCell : UITableViewCell
@property(nonatomic,strong)YYAnimatedImageView * bookImageView;
@property(nonatomic,strong)UILabel * bookNameLabel;
@property(nonatomic,strong)UILabel * bookAuthorLabel;
@property(nonatomic,strong)UILabel * bookMessageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;

@property(nonatomic,strong)SR_BookClubBookModel * bookModel;
@end
