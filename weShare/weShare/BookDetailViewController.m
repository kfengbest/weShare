//
//  BookDetailViewController.m
//  weShare
//
//  Created by Kaven Feng on 5/5/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "BookDetailViewController.h"
#import "./DataModel/NBook.h"
#import "MsgViewController.h"

@interface BookDetailViewController ()
{
    
}
@end

@implementation BookDetailViewController
@synthesize book;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.book != nil) {
        UIImage *bookImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.book.imageUrl]]];
        self.bookThumbnail.image = bookImage;  // network image
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_bookThumbnail release];
    [_bookLongDes release];
    [_btnMsg release];
    [super dealloc];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSendMsg:(id)sender {
    
    MsgViewController* msgCon = [[MsgViewController alloc] initWithNibName:@"MsgViewController" bundle:nil];
    [self.navigationController  pushViewController:msgCon animated:YES];
    
//    MsgViewController* msgCon = [[MsgViewController alloc] initWithNibName:@"MsgViewController" bundle:nil];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:msgCon];
//    [self presentViewController:nav animated:YES completion:nil];
}
@end
