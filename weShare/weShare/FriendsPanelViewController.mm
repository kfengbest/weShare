//
//  FriendsPanelViewController.m
//  weShare
//
//  Created by fengka on 1/26/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "FriendsPanelViewController.h"
#import <vector>
#import "StringConvert.h"
#import "ConstStrings.h"
#import "../JSONKit/JSONKit.h"
#import "DataModel/NUser.h"
#import "BooksViewController.h"
#import "../SideBar/SideBarSelectedDelegate.h"

@interface FriendsPanelViewController ()
{
    NSString* _sessionID;
    NSMutableArray* _friendsList;
    
    int _selectIdnex;

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
        
    
    _friendsList = [[NSMutableArray alloc] init];
    [self loadSession];
    [self loadUsers];
    
    if ([self.delegate respondsToSelector:@selector(rightSideBarSelectWithController:)]) {
        [self.delegate rightSideBarSelectWithController :[self subConWithIndex:0]];
        _selectIdnex = 0;
    }
    
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
    NSString *strGetFriendsInfo = [NSString stringWithFormat:@"%@%@%@%@%@",s_strApi,s_strOp, s_GetFriendsBySession,s_strSessionParm, _sessionID];
    NSURL* urlGetFriends = [NSURL URLWithString:strGetFriendsInfo];
    NSURLRequest* reqGetFriends = [NSURLRequest requestWithURL:urlGetFriends];
    NSError* err2 = nil;
    NSURLResponse* resGetFriends = nil;
    NSData* friendsData = [NSURLConnection sendSynchronousRequest:reqGetFriends returningResponse:&resGetFriends error:&err2];
 //   NSDictionary* friendsDictionary = [friendsData objectFromJSONData];
 //   NSLog(@"friendsDictionary: %@", friendsDictionary);
 //   NSArray* arrValues = [friendsDictionary allValues];
    
    NSArray* arrValues = [friendsData objectFromJSONData];
    for (NSDictionary *friendsDic in arrValues)
    {
        NUser* pFriend = [[NUser alloc] init];
        [_friendsList addObject:pFriend];
        NSString* strId = (NSString*)[friendsDic objectForKey:@"id"];
        pFriend.userId =  [strId intValue];
        pFriend.name = (NSString*)[friendsDic objectForKey:@"nickname"];
        pFriend.sessionId = _sessionID;
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// TableView.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendsList count];
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
    NUser* pUser = [_friendsList objectAtIndex:n];
    cell.textLabel.text = pUser.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(rightSideBarSelectWithController:)]) {
        if (indexPath.row == _selectIdnex) {
            [self.delegate rightSideBarSelectWithController:nil];
        }else
        {
            NSLog(@"selected %d", indexPath.row);
            [self.delegate rightSideBarSelectWithController:[self subConWithIndex:indexPath.row]];
        }
        
    }
    _selectIdnex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UINavigationController *)subConWithIndex:(int)index
{
    BooksViewController *con = [[BooksViewController alloc] initWithNibName:@"BooksViewController" bundle:nil];
    con.user = [_friendsList objectAtIndex:index];
    [con reload];
    
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:con];
    nav.navigationBar.hidden = YES;
    return nav ;
}
@end
