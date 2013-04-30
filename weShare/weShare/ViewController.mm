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
    NSString* _sessionID;
    NSMutableArray* _booksList;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _booksList = [[NSMutableArray alloc] init];
    
    UINib* nib = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"BookCellID"];
//    [self.collectionView registerClass:[BookCell class] forCellWithReuseIdentifier:@"BookCellID"];
  
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView setCollectionViewLayout:flowLayout];
    
//  [self testWS];
    [self loadSession];
    [self loadBooksByUser:nil];
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
    
    [_booksList addObject:pBook];
    
    [self.collectionView reloadData];
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

-(void) loadSession{
    NSURL* url1 = [NSURL URLWithString:s_loginUrl];
    NSURLRequest* req = [NSURLRequest requestWithURL:url1];
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSData* resData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
    _sessionID = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    //NSLog(@"Session: %@", _sessionID);
}

-(void) loadBooksByUser : (NUser*) user{
    NSString* strGetBooks = [NSString stringWithFormat:@"%@%@%@%@%@", s_strApi, s_strOp, s_GetBooksBySession, s_strSessionParm, _sessionID];
    NSURL* urlGetBooks = [NSURL URLWithString:strGetBooks];
    NSURLRequest* reqGetBooks = [NSURLRequest requestWithURL:urlGetBooks];
    NSURLResponse* resBooks = nil;
    NSError* err3 = nil;
    NSData* booksData = [NSURLConnection sendSynchronousRequest:reqGetBooks returningResponse:&resBooks error:&err3];
    
    NSArray* arrValues = [booksData objectFromJSONData];
    for (NSDictionary *bookDic in arrValues)
    {
        NBook* pBook = [[NBook alloc] init];
        pBook.isbn = (NSString*)[bookDic objectForKey:@"isbn"];
        [self loadBook: pBook];
        [_booksList addObject:pBook];
    }
    
    [self.collectionView reloadData];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_booksList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCellID" forIndexPath:indexPath];
    
    int n = (int)indexPath.row;
    NBook* pBook = (NBook*)[_booksList objectAtIndex:n];
    


    UIImageView* iv = (UIImageView*)[cell viewWithTag:1];
    
    UIImage *bookImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pBook.imageUrl]]];
    iv.image = bookImage;  // network image
   // iv.image = pBook.imageScaned;
    
//    if (pBook.imageDownloaded != nil) {
//        iv.image = pBook.imageDownloaded;
//    }else{
//        iv.image = pBook.imageScaned;
//    }
    
    return cell;
    
}

@end
