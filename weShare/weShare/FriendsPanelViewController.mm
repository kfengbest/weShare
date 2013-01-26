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

@interface FriendsPanelViewController ()
{
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
