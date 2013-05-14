//
//  MsgViewController.h
//  weShare
//
//  Created by Kaven Feng on 5/14/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../MessagesTableViewController/MessagesViewController.h"

@interface MsgViewController : MessagesViewController
{
    
}

@property (strong, nonatomic) NSMutableArray *messages;

@end
