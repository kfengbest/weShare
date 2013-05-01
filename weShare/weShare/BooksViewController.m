//
//  BooksViewController.m
//  weShare
//
//  Created by Kaven Feng on 4/30/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "BooksViewController.h"
#import "DataModel/NUser.h"
#import "DataModel/NBook.h"

#import "BookCell.h"
#import "ConstStrings.h"

#import "../JSONKit/JSONKit.h"
#import "../EGOImageLoading/EGOImageView/EGOImageView.h"

@interface BooksViewController ()
{
    NSMutableArray* _booksList;

}
@end

@implementation BooksViewController
@synthesize collectionView;
@synthesize user;

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
    
    if (_booksList == nil) {
        _booksList = [[NSMutableArray alloc] init];
    }
    
    UINib* nib = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"BookCellID"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView setCollectionViewLayout:flowLayout];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) loadBooksByUser : (NUser*) pUser{
    if (pUser == nil) {
        return;
    }
    
    if (_booksList == nil) {
        _booksList = [[NSMutableArray alloc] init];
    }
    NSString* strGetBooks = [NSString stringWithFormat:@"%@%@%@%@%@%@%d", s_strTestApi, s_strOp, s_GetBooksByOwner, s_strSessionParm, pUser.sessionId, s_strOwnerId, pUser.userId ];
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

-(void) reload{
    if (self.user != nil) {
        [self loadBooksByUser:self.user];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    int i = [_booksList count];
    return [_booksList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)pCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [pCollectionView dequeueReusableCellWithReuseIdentifier:@"BookCellID" forIndexPath:indexPath];

    int n = (int)indexPath.row;
    NBook* pBook = (NBook*)[_booksList objectAtIndex:n];

    UIImageView* iv = (UIImageView*)[cell viewWithTag:1];
    UIImage *bookImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pBook.imageUrl]]];
    iv.image = bookImage;  // network image


    return cell;

}
@end
