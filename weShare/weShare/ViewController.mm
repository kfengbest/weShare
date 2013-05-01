//
//  ViewController.m
//  weShare
//
//  Created by fengka on 1/24/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "ViewController.h"
#import "../JSONKit/JSONKit.h"
#import "../EGOImageLoading/EGOImageView/EGOImageView.h"

#import "FriendsPanelViewController.h"
#import "UserPanelViewController.h"
#import "DataModel/NBook.h"
#import "DataModel/NUser.h"

#import "BookCell.h"
#import "ConstStrings.h"


@interface ViewController ()
{
    UIViewController  *_currentMainController;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(LeftSideBarViewController*) createLeftSideBarController
{
    if (self.leftSideBarViewController == nil) {
        self.leftSideBarViewController = [[UserPanelViewController alloc] initWithNibName:@"UserPanelViewController" bundle:nil];
    }
    
    return self.leftSideBarViewController;
}

-(RightSideBarViewController*) createRightSideBarController
{
    if (self.rightSideBarViewController == nil) {
        self.rightSideBarViewController = [[FriendsPanelViewController alloc] initWithNibName:@"FriendsPanelViewController" bundle:nil];
    }
    
    return self.rightSideBarViewController;
}

- (void)leftSideBarSelectWithController:(UIViewController *)controller
{

}


- (void)rightSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
		controller.view.frame = self.contentView.bounds;
		_currentMainController = controller;
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
	} else if (_currentMainController != controller && controller !=nil) {
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_currentMainController removeFromParentViewController];
									[controller didMoveToParentViewController:self];
									_currentMainController = controller;
								}
         ];
	}
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onScan:(id)sender {
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    // do something useful with results
    for(ZBarSymbol *sym in symbols) {
        NSString* str = sym.data;
        NSLog(str);
        
        break;
    }
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    //    imageview.image =
    //    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissModalViewControllerAnimated: YES];
    
    NSString* str =  symbol.data ;
    NSLog(str);
    //[self loadBook:@"1220562"];
    NBook* pBook = [[NBook alloc] init];
    pBook.imageScaned = [info objectForKey:UIImagePickerControllerOriginalImage];
    pBook.isbn = str;
    [self loadBook: pBook];
    
   // [_booksList addObject:pBook];
    
}

- (void) loadBook:(NBook*)book
{
    NSString* isbn = book.isbn;
    
    NSString* bookAPI = [s_DoubanAPI stringByAppendingString:isbn];    
    
    NSURL* url = [NSURL URLWithString:bookAPI];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSDictionary* resultDic = [jsonData objectFromJSONData];
    
 //   NSLog(@"result: %@", resultDic);
    NSString* midImgURL = [resultDic objectForKey:@"image"];
    book.imageUrl = midImgURL;
    
    // sync loading images.
//    UIImage *bookImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:midImgURL]]];
//    UIImageView* bookImageView = [[UIImageView alloc] initWithImage:bookImage];
//    [bookImageView setFrame:CGRectMake(10, 10, bookImage.size.width, bookImage.size.height)];
//    [self.view addSubview:bookImageView];

    // Async loading image.
    EGOImageView* imageView = [[EGOImageView alloc] initWithPlaceholderImage:book.imageScaned];
///    imageView.frame = CGRectMake(10, 10, 80, 100);
    imageView.imageURL = [NSURL URLWithString:midImgURL];
   // [self.view addSubview:imageView];
    book.imageDownloaded = imageView.image;
    
}

-(void) testWS
{
    NSURL* url1 = [NSURL URLWithString:s_loginUrl];
    NSURLRequest* req = [NSURLRequest requestWithURL:url1];
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSData* resData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
    NSString* strSession = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strSession);
    
  
    NSString *strGetUserInfo = [NSString stringWithFormat:@"%@%@%@%@%@",s_strApi,s_strOp, s_GetUserInfoBySession,s_strSessionParm, strSession];
    NSURL* urlGetUser = [NSURL URLWithString:strGetUserInfo];
    NSURLRequest* reqGetUser = [NSURLRequest requestWithURL:urlGetUser];
    NSError* err2 = nil;
    NSURLResponse* resGetUser = nil;
    NSData* userData = [NSURLConnection sendSynchronousRequest:reqGetUser returningResponse:&resGetUser error:&err2];
    NSDictionary* userDic = [userData objectFromJSONData];
    NSLog(@"user: %@", userDic);

    NSString* strGetBooks = [NSString stringWithFormat:@"%@%@%@%@%@", s_strApi, s_strOp, s_GetBooksBySession, s_strSessionParm, strSession];
    NSURL* urlGetBooks = [NSURL URLWithString:strGetBooks];
    NSURLRequest* reqGetBooks = [NSURLRequest requestWithURL:urlGetBooks];
    NSURLResponse* resBooks = nil;
    NSError* err3 = nil;
    NSData* booksData = [NSURLConnection sendSynchronousRequest:reqGetBooks returningResponse:&resBooks error:&err3];
    NSDictionary* booksDic = [booksData objectFromJSONData];
    NSLog(@"books: %@", booksDic);
    
}


@end
