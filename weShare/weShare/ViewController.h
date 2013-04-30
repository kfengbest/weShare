//
//  ViewController.h
//  weShare
//
//  Created by fengka on 1/24/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../ZBarSDK/Headers/ZBarSDK/ZBarSDK.h"
#import "../SideBar/SideBarViewController.h"

@class NBook;

//@interface ViewController : SideBarViewController<ZBarReaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate>
@interface ViewController : SideBarViewController<ZBarReaderDelegate,UINavigationControllerDelegate>

{
    
}

@property(strong, nonatomic) IBOutlet UICollectionView* collectionView;

- (IBAction)onScan:(id)sender;

- (void) loadBook:(NBook*)book;

@end
