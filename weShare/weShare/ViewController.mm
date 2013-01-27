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

@interface ViewController ()
{
    NSMutableArray* _booksList;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _booksList = [[NSMutableArray alloc] initWithObjects:@"kaven",@"feng", nil];
    
    //[self testWS];
    
    UINib* nib = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"BookCellID"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(UIViewController*) createLeftSideBarController
{
    if (self.leftSideBarViewController == nil) {
        self.leftSideBarViewController = [[UserPanelViewController alloc] initWithNibName:@"UserPanelViewController" bundle:nil];
    }
    
    return self.leftSideBarViewController;
}

-(UIViewController*) createRightSideBarController
{
    if (self.rightSideBarViewController == nil) {
        self.rightSideBarViewController = [[FriendsPanelViewController alloc] initWithNibName:@"FriendsPanelViewController" bundle:nil];
    }
    
    return self.rightSideBarViewController;
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
    [self loadBookByIsbn:str];
}

- (void) loadBookByIsbn:(NSString*) isbn
{
    static NSString* s_DoubanAPI = @"https://api.douban.com/v2/book/isbn/";
    NSString* bookAPI = [s_DoubanAPI stringByAppendingString:isbn];    
    
    NSURL* url = [NSURL URLWithString:bookAPI];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSDictionary* resultDic = [jsonData objectFromJSONData];
    
 //   NSLog(@"result: %@", resultDic);
    NSString* midImgURL = [resultDic objectForKey:@"image"];
    
//    UIImage *bookImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:midImgURL]]];
//    UIImageView* bookImageView = [[UIImageView alloc] initWithImage:bookImage];
//    [bookImageView setFrame:CGRectMake(10, 10, bookImage.size.width, bookImage.size.height)];
//    [self.view addSubview:bookImageView];

    
    EGOImageView* imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"Default.png"]];
    imageView.frame = CGRectMake(10, 10, 80, 100);
    imageView.imageURL = [NSURL URLWithString:midImgURL];
    [self.view addSubview:imageView];
}

-(void) testWS
{
    static NSString* urlStr1 = @"http://services.sketchbook.cn/openlib/service_test/api.php?op=Login&email=tom.dong@openlib.com&localpwd=c01abe74c44be79ce0bec6f042353064";
    NSURL* url1 = [NSURL URLWithString:urlStr1];
    NSURLRequest* req = [NSURLRequest requestWithURL:url1];
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSData* resData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
    NSString* strSession = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strSession);
    
    static NSString* s_strApi = @"http://services.sketchbook.cn/openlib/service_test/api.php?";
    static NSString* s_strOp = @"op=";
    static NSString* s_strSessionParm = @"&sessionid=";
    
    NSString* s_GetUserInfoBySession = @"GetUserInfoBySession";
    NSString* s_GetBooksBySession = @"GetBooksBySession";

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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCellID" forIndexPath:indexPath];
    return cell;
    
    
    return cell;
}

@end
