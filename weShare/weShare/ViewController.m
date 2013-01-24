//
//  ViewController.m
//  weShare
//
//  Created by fengka on 1/24/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "ViewController.h"
#import "../JSONKit/JSONKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button:(id)sender {
    
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
    
    UIImage *bookImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:midImgURL]]];
    UIImageView* bookImageView = [[UIImageView alloc] initWithImage:bookImage];
    [bookImageView setFrame:CGRectMake(10, 10, bookImage.size.width, bookImage.size.height)];
    [self.view addSubview:bookImageView];

}


@end
