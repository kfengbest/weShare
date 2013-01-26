//
//  FriendsPanelViewController.h
//  weShare
//
//  Created by fengka on 1/26/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../SideBar/RightSideBarViewController.h"

@interface FriendsPanelViewController : RightSideBarViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(strong, nonatomic) IBOutlet UITableView* friendsTableView;

@end
