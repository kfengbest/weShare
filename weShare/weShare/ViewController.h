//
//  ViewController.h
//  weShare
//
//  Created by fengka on 1/24/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../ZBarSDK/Headers/ZBarSDK/ZBarSDK.h"

@interface ViewController : UIViewController<ZBarReaderDelegate>
{
    
}

- (IBAction)button:(id)sender;

@end
