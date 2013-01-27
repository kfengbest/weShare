//
//  FriendsPanelViewController.h
//  weShare
//
//  Created by fengka on 1/26/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsPanelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(strong, nonatomic) IBOutlet UITableView* friendsTableView;

@end
