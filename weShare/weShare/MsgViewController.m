//
//  MsgViewController.m
//  weShare
//
//  Created by Kaven Feng on 5/14/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "MsgViewController.h"

@interface MsgViewController ()

@end

@implementation MsgViewController

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

        UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
        [self.view addSubview:navBar];
    
        UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle: @"Message"];
        navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        [navBar pushNavigationItem:navItem animated:NO];
    
    
    
    self.title = @"Messages";
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     @"Testing some messages here.",
                     @"This work is based on Sam Soffes' SSMessagesViewController.",
                     @"This is a complete re-write and refactoring.",
                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
                     nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view controller
- (BubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? BubbleMessageStyleIncoming : BubbleMessageStyleOutgoing;
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}



static NSString* s_postURL = @"http://www.gokaven.com/cloud_api/index.php?op=SendMessage&sessionid=2beb248c-9208-b5fd-12df-a02d5878574b&replyid=5&friendid=2&isbn=9787564101657";

//static NSString* s_postURL = @"http://localhost/~fengka/cloud_api/index.php?op=SendMessage&sessionid=2beb248c-9208-b5fd-12df-a02d5878574b&replyid=5&friendid=2&isbn=9787564101657";


- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messages addObject:text];
    
    if((self.messages.count - 1) % 2)
        [MessageSoundEffect playMessageSentSound];
    else
        [MessageSoundEffect playMessageReceivedSound];
    
    [self postMessage:text URL:s_postURL];
    
    [self finishSend];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)postMessage:(NSString *)strcontext URL:(NSString *)urlstr{
    
    
    NSString* post = [[NSString alloc] initWithFormat:@"message=%@",strcontext];
  
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlstr]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    
    if (error) {
        NSLog(@"Something wrong: %@",[error description]);
    }else {
        if (returnData) {
            NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            NSLog(@"get %@",responseString);
        }
    }
}

@end
