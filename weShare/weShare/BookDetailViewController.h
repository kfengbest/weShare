//
//  BookDetailViewController.h
//  weShare
//
//  Created by Kaven Feng on 5/5/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBook;
@interface BookDetailViewController : UIViewController
{
    
}

@property(nonatomic, strong) NBook* book;
@property (retain, nonatomic) IBOutlet UIImageView *bookThumbnail;
@property (retain, nonatomic) IBOutlet UILabel *bookLongDes;
@property (retain, nonatomic) IBOutlet UIButton *btnMsg;
- (IBAction)onSendMsg:(id)sender;

@end
