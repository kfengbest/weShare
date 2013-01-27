//
//  NBook.h
//  weShare
//
//  Created by fengka on 1/27/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBook : NSObject
{
    
}

@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* isbn;
@property(strong, nonatomic) NSString* imageUrl;
@property(strong, nonatomic) UIImage*  imageScaned;
@property(strong, nonatomic) UIImage*  imageDownloaded;

@end
