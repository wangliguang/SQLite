//
//  ViewController.m
//  sqlite
//
//  Created by GG on 16/1/4.
//  Copyright © 2016年 王立广. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
@interface ViewController ()
{
    //数据库指针
    sqlite3 *sqlite;
    //结果集，用来存放查询到的结果
    sqlite3_stmt *stmt;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTable];
    
    [self insert:@"小红" WithAge:12];
    
    [self queryAgeOfName:@"小红"];
    
    
    
    

}

- (void)queryAgeOfName:(NSString *)name{
    
    [self openDB];
    
    NSString *sql = @"SELECT * FROM User WHERE name = ?";
    
    //编译SQL语句
    int result = sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    
    sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
    
    //执行sql语句，返回的结果如果==SQLITE_ROW，表明有另一行语句已准备好
    result = sqlite3_step(stmt);
    
    while (result == SQLITE_ROW) {
        
        /*
         * char *name = (char *)sqlite3_column_text(stmt, 0);
         * 第一个参数：结果集
         * 第二个参数：第一条数据的第几列上的数据
         */
        char *name = (char *)sqlite3_column_text(stmt, 0);
        int age = sqlite3_column_int(stmt, 1);
       
        NSString *kname = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@的年龄是%d",kname,age);
        
        //执行之前准备好的语句
        result = sqlite3_step(stmt);
    }
    
    [self closeDB];

}

- (void)insert:(NSString *)name WithAge:(int )age{
    
    [self openDB];
        
    NSString *sql = @"INSERT INTO User(name,age) VALUES (?,?)";
    
    /*
     * sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
     * 第一个参数：数据库指针
     * 第二个参数：sql语句，使用UTF-8编码
     * 第三个参数：sql语句执行的字节长度，-1表示该语句全部执行。
     * 第四个参数：返回一个结果集
     * 第五个参数：存放没有执行的sql语句
     */
    //编译SQL语句，返回一个结果集
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL);
    /*
     * sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
     * 第一个参数：数据库指针
     * 第二个参数：序号，也就说绑定在第几个问号(从1开始)
     * 第三个参数：绑定的数据
     * 第四个参数：sql语句执行的字节长度，-1表示该语句全部执行。
     * 第五个参数：回调函数，语句执行完毕后会调用。
     */
    //将传进来的值放到将要插入表中的结果集。
    sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 2, age);
    
    //执行SQL语句，保存数据
    int result = sqlite3_step(stmt);
        
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"执行SQL语句失败");
        return;
    }
        
    [self closeDB];
    NSLog(@"数据插入成功");
    
}

- (void)createTable{
    
    [self openDB];
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS User (name TEXT,age INTEGER)";
    
    /*
     * int result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &error);
     * 第一个参数：打开数据库时获取到的sqlite3的指针
     * 第二个参数：是一条sql语句
     * 第三个参数：是回调参数，到这条语句执行之后会调用提供的回调函数
     * 第四个参数：是指针参数，这个参数最终会传到回调函数的第一个参数里
     * 第五个参数：是错误信息
     * 返 回  值：该操作是否成功。
     * 说明：通常，sqlite3_callback 和它后面的void*这两个位置都可以填NULL。填NULL表示你不需要回调。比如你做insert 操作，做delete操作，就没有必要使用回调。而当你做select 时，就要使用回调，因为sqlite3 把数据查出来，得通过回调告诉你查出了什么数据。
     */
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


- (void)openDB
{
    //数据库指针
    sqlite = nil;
    //结果集，用来存放查询到的结果
    stmt = nil;
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/data.sqlite"];
    
    NSLog(@"数据库所在路径%@",filePath);
    
    /*
     * int result = sqlite3_open([filePath UTF8String], &sqlite);
     * 打开数据库，如果在路径上没有这个数据库，系统就会自动创建一个数据库。
     * 第一个参数：数据库所在的路径，由于sqlite是C语言编写的，通过[filePath UTF8String]将OC的字符串转化为C的字符串。
     * 第二个参数：数据库指针，这个参数是指针的指针。这句代码运行完以后会给sqlite指针赋值。
     */
    //打开数据库
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return;
    }
}


- (void)closeDB
{
    //关闭结果集
    sqlite3_finalize(stmt);
    
    //关闭数据库
    sqlite3_close(sqlite);
}


@end
