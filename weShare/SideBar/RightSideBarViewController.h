//
//  RightSideBarViewController.h
//  weShare
//
//  Created by fengka on 1/25/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideBarSelectDelegate ;

@interface RightSideBarViewController : UIViewController
{
    
}

@property (assign,nonatomic)id<SideBarSelectDelegate>delegate;

@end
