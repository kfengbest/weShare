//
//  NUser.h
//  weShare
//
//  Created by fengka on 1/28/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUser : NSObject
{
    
}

@property NSInteger userId;
@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* email;
@property(strong, nonatomic) NSString* urlPhoto;

@end
