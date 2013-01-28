//
//  UserPanelViewController.m
//  weShare
//
//  Created by fengka on 1/26/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "UserPanelViewController.h"
#import "../DBLayer/connectionsqlite.h"
#import "../DBLayer/dbrecordbuffer.h"
#import "../DBLayer/dbfield.h"

@interface UserPanelViewController ()

@end

@implementation UserPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    std::string sql = "select * from Users;";
    std::vector<DbRecordBuffer*> pRecords;
    ConnectionSqlite::get()->ExecuteSql(sql,pRecords);
    int n = pRecords.size();
    for (int i = 0; i < n; i++) {
        DbRecordBuffer* pBuffer = pRecords.at(i);
        int nf = pBuffer->count();
        
    }
    
//    std::string sqlInsert = "insert into Users values(100,'amy','email');";
//    ConnectionSqlite::get()->ExecuteSql(sqlInsert);

//    std::string sqlDel = "delete from Users where aimkey = 3";
//    ConnectionSqlite::get()->ExecuteSql(sqlDel);


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
