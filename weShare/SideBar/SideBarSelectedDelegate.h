//
//  SideBarSelectedDelegate.h
//  weShare
//
//  Created by fengka on 1/25/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#ifndef weShare_SideBarSelectedDelegate_h
#define weShare_SideBarSelectedDelegate_h

#import <Foundation/Foundation.h>

typedef enum _SideBarShowDirection
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1,
    SideBarShowDirectionRight = 2
}SideBarShowDirection;

@protocol SideBarSelectedDelegate <NSObject>

-(void) leftSideBarSelectWithController:(UIViewController*)controller;
-(void) rightSideBarSelectWithController:(UIViewController*)controller;
-(void) showSideBarControllerWithDirection:(SideBarShowDirection)direction;

@end


#endif
