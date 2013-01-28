//
//  FriendsPanelViewController.m
//  weShare
//
//  Created by fengka on 1/26/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "FriendsPanelViewController.h"
#import "DataModel/Friend.h"
#import <vector>
#import "StringConvert.h"
#import "ConstStrings.h"
#import "../JSONKit/JSONKit.h"


@interface FriendsPanelViewController ()
{
    NSString* _sessionID;
    std::vector<Friend*> _friendsVec;
}

@end

@implementation FriendsPanelViewController
@synthesize friendsTableView;

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
        
    
    Friend* f1 = new Friend();
    f1->name(L"凯");
    
    Friend* f2 = new Friend();
    f2->name(L"Feng");
    
    _friendsVec.push_back(f1);
    _friendsVec.push_back(f2);

    [self loadSession];
    [self loadUsers];
    
}

-(void) loadSession
{
    NSURL* url1 = [NSURL URLWithString:s_loginUrl];
    NSURLRequest* req = [NSURLRequest requestWithURL:url1];
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSData* resData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
    _sessionID = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    //NSLog(@"Session: %@", _sessionID);

}

-(void) loadUsers
{
    NSString *strGetUserInfo = [NSString stringWithFormat:@"%@%@%@%@%@",s_strApi,s_strOp, s_GetUserInfoBySession,s_strSessionParm, _sessionID];
    NSURL* urlGetUser = [NSURL URLWithString:strGetUserInfo];
    NSURLRequest* reqGetUser = [NSURLRequest requestWithURL:urlGetUser];
    NSError* err2 = nil;
    NSURLResponse* resGetUser = nil;
    NSData* userData = [NSURLConnection sendSynchronousRequest:reqGetUser returningResponse:&resGetUser error:&err2];
    NSDictionary* userDic = [userData objectFromJSONData];
    NSLog(@"user: %@", userDic);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// TableView.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendsVec.size();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString* CellIdentifier = @"FriendCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
        
    int n = (int)indexPath.row;
    std::wstring wStr = _friendsVec.at(n)->name();
    cell.textLabel.text = [NSString stringWithwstring:wStr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
