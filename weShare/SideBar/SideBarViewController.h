//
//  SideBarViewController.h
//  weShare
//
//  Created by fengka on 1/25/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarSelectedDelegate.h"
#import "LeftSideBarViewController.h"
#import "RightSideBarViewController.h"

@interface SideBarViewController : UIViewController<SideBarSelectedDelegate>
{
    
}

@property(strong, nonatomic) IBOutlet UIView* contentView;
@property(strong, nonatomic) IBOutlet UIView* navBackView;
@property(strong, nonatomic) LeftSideBarViewController* leftSideBarViewController;
@property(strong, nonatomic) RightSideBarViewController* rightSideBarViewController;

-(LeftSideBarViewController*) createLeftSideBarController;
-(RightSideBarViewController*) createRightSideBarController;

@end
