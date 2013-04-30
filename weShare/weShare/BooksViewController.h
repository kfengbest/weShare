//
//  BooksViewController.h
//  weShare
//
//  Created by Kaven Feng on 4/30/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NUser;

@interface BooksViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property(strong, nonatomic) IBOutlet UICollectionView* collectionView;
@property (assign,nonatomic) NUser* user;

-(void) reload;

@end
