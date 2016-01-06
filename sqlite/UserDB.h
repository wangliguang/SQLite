//
//  UserDB.h
//  SQLiteDemo
//
//  Created by WY on 13-2-27.
//  Copyright (c) 2013年 puke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
@interface UserDB : NSObject
{
    sqlite3 *sqlite;
    sqlite3_stmt *stmt;
}


//创建表
- (void)createTable;

//插入数据
- (void)insertWeek:(NSString *)week num1:(NSString *)num1 num2:(NSString *)num2 num3:(NSString *)num3 num4:(NSString *)num4 remakr:(NSString *)remark;

//查询数据
- (NSMutableArray *)selectWeek:(NSString *)week;

//更新数据
-(void *)updateData:(NSString *)week num1:(NSString *)num1 num2:(NSString *)num2 num3:(NSString *)num3 num4:(NSString *)num4 remakr:(NSString *)remark;


@end
