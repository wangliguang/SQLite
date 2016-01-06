//
//  UserDB.m
//  SQLiteDemo
//
//  Created by WY on 13-2-27.
//  Copyright (c) 2013年 puke. All rights reserved.
//

#import "UserDB.h"
#import <sqlite3.h>

@implementation UserDB


#pragma mark ************创建表**************
- (void)createTable
{
    [self openDB];
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS User (week TEXT primary key,num1 TEXT,num2 TEXT,num3 TEXT,num4 TEXT,remark TEXT)";

    //执行sql语句
   char *error;
   int result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &error);
    if (result != SQLITE_OK) {
        NSLog(@"创建表失败：%s",error);
        return;
    }
    
    [self closeDB];
    NSLog(@"创建表成功!");
    
}

#pragma mark ************插入数据**************
- (void)insertWeek:(NSString *)week num1:(NSString *)num1 num2:(NSString *)num2 num3:(NSString *)num3 num4:(NSString *)num4 remakr:(NSString *)remark
{

    [self openDB];
    
    NSString *sql = @"INSERT INTO User(week,num1,num2,num3,num4,remark) VALUES (?,?,?,?,?,?)";
    //编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    //往SQL语句上填充绑定数据
    
    sqlite3_bind_text(stmt, 1, [week UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [num1 UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [num2 UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [num3 UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [num4 UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 6, [remark UTF8String], -1, NULL);
    
    //执行SQL语句
    int result = sqlite3_step(stmt);

    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"执行SQL语句失败");
        return;
    }
    
    [self closeDB];
    NSLog(@"数据插入成功");
}

#pragma mark ************查询数据**************
- (NSMutableArray *)selectWeek:(NSString *)week
{
    [self openDB];
    
    NSString *sql = @"SELECT week,num1,num2,num3,num4,remark FROM USER WHERE week=?";
    
    //编译SQL语句
    int result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        return nil;
    }
    
    sqlite3_bind_text(stmt, 1, [week UTF8String], -1, NULL);
    
    //查询数据
    NSMutableArray *returnArray;
    result = sqlite3_step(stmt);
    while (result == SQLITE_ROW) {
        char *week = (char *)sqlite3_column_text(stmt, 0);
        char *num1 = (char *)sqlite3_column_text(stmt, 1);
        char *num2 = (char *)sqlite3_column_text(stmt, 2);
        char *num3 = (char *)sqlite3_column_text(stmt, 3);
        char *num4 = (char *)sqlite3_column_text(stmt, 4);
        char *remakr = (char *)sqlite3_column_text(stmt, 5);

        NSString *weekString = [NSString stringWithCString:week encoding:NSUTF8StringEncoding];
        NSString *num1String = [NSString stringWithCString:num1 encoding:NSUTF8StringEncoding];
        NSString *num2String = [NSString stringWithCString:num2 encoding:NSUTF8StringEncoding];
        NSString *num3String = [NSString stringWithCString:num3 encoding:NSUTF8StringEncoding];
        NSString *num4String = [NSString stringWithCString:num4 encoding:NSUTF8StringEncoding];
        NSString *remakrString = [NSString stringWithCString:remakr encoding:NSUTF8StringEncoding];

        NSLog(@"----日期：%@,num1：%@, num2：%@, num3：%@, num4：%@, remark：%@-----",weekString,num1String,num2String,num3String,num4String,remakrString);
        
        returnArray = @[weekString,num1String,num2String,num3String,num4String,remakrString];
        
       
    
        result = sqlite3_step(stmt);
    }
    
    return returnArray;
    
    [self closeDB];
    
    
}

#pragma mark ************更新数据**************
-(void)updateData:(NSString *)week num1:(NSString *)num1 num2:(NSString *)num2 num3:(NSString *)num3 num4:(NSString *)num4 remakr:(NSString *)remark
{
    
    [self openDB];
    
    NSString *sql =@"INSERT OR REPLACE INTO user(week,num1,num2,num3,num4,remark)""VALUES(?,?,?,?,?,?)";

    //编译SQL语句
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    //往SQL语句上填充绑定数据
    sqlite3_bind_text(stmt, 1, [week UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [num1 UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [num2 UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [num3 UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [num4 UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 6, [remark UTF8String], -1, NULL);
    
    //执行SQL语句
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"执行SQL语句失败");
        return;
    }
    
    [self closeDB];
    NSLog(@"数据更新成功");
}



- (void)openDB
{
    sqlite = nil;
    stmt = nil;
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/data.sqlite"];
    
    //打开数据库
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return;
    }
}
- (void)closeDB
{
    //关闭数据库句柄
    sqlite3_finalize(stmt);
    
    //关闭数据库
    sqlite3_close(sqlite);
}
@end
