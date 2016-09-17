//
//  SR_BookClubBookModel.m
//  scanreader
//
//  Created by jbmac01 on 16/8/16.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BookClubBookModel.h"

@implementation SR_BookClubBookModel
/**
 *  每个数据模型就创建一个table,表的名称与文件保持一致
 *
 *  @return <#return value description#>
 */
+ (NSString *)getTableName
{
    return @"SR_BookClubBookModel";
}
/**
 *  插入一个模型
 *
 *  @param inDBModel <#inDBModel description#>
 */
+ (void)insertModel:(SR_BookClubBookModel *)Model
{
    [[SR_BookClubBookModel getUsingLKDBHelper] insertWhenNotExists:Model];
}

/**
 *  查询多少个
 *
 *  @param where <#where description#>
 *  @param order <#order description#>
 *  @param count <#count description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableArray *)queryModelWihtWhere:(id)where
                                orderBy:(NSString *)order
                                  count:(NSUInteger)count
{
    return [SR_BookClubBookModel searchWithWhere:where orderBy:order offset:0 count:count];
}


+ (NSMutableArray *)queryModelWihtComplexSQL:(NSString *)SQL
{
    return [[SR_BookClubBookModel getUsingLKDBHelper] searchWithSQL:SQL toClass:[SR_BookClubBookModel class]];
}
//可以进一步封装，通过传入多个参数来实现多条件查询
/**
 *  通过属性方式查询
 *
 *  @param key      <#key description#>
 *  @param property <#property description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableArray *)queryModelWithWhere:(id)key property:(id)property
{
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = '%@'",[self getTableName],key,property];
    return  [self queryModelWihtComplexSQL:sql];
}
/**
 *  根据属性来删除对应的模型
 *
 *  @param key      <#key description#>
 *  @param property <#property description#>
 */
+ (void)deleteModel:(id)key property:(id)property
{
    [[SR_BookClubBookModel getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = '%@'",[self getTableName],key,property];
        [db executeUpdate:sql];
    }];
}
/**
 *  通过获取之前的模型,然后这个删除该模型的数据
 *
 *  @param model <#model description#>
 */
+ (void)deleteModel:(SR_BookClubBookModel *)model
{
    BOOL ishas = [[SR_BookClubBookModel getUsingLKDBHelper] isExistsModel:model];
    if (ishas) {
        [[SR_BookClubBookModel getUsingLKDBHelper] deleteToDB:model];
    }
}

@end
