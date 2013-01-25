//
//  SideBarViewController.m
//  weShare
//
//  Created by fengka on 1/25/13.
//  Copyright (c) 2013 adsk. All rights reserved.
//

#import "SideBarViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SideBarViewController ()
{
    UIPanGestureRecognizer* _panGestureRecognizer;
    UITapGestureRecognizer* _tapGestureRecognizer;
    
    CGFloat currentTranslate;
    BOOL sideBarShowing;

}
@end

@implementation SideBarViewController
@synthesize contentView, navBackView, leftSideBarViewController, rightSideBarViewController;

static SideBarViewController* rootViewCon;
const int ContentOffset = 230;
const int ContentMinOffset = 60;
const float MoveAnimationDuration = 0.3;

+(id) shared
{
    return rootViewCon;
}

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
    if (rootViewCon) {
        rootViewCon = nil;
    }
    rootViewCon = self;
    
    // init internal state.
    sideBarShowing = NO;
    currentTranslate = 0;
    
    // create left/right viewcontroller and added them as child controller;
    self.leftSideBarViewController = [[LeftSideBarViewController alloc] initWithNibName:@"LeftSideBarViewController" bundle:nil];
    //self.leftSideBarViewController.delegate = self;
    self.rightSideBarViewController = [[RightSideBarViewController alloc] initWithNibName:@"RightSideBarViewController" bundle:nil];
    //self.rightSideBarViewController.delegate = self;
    [self addChildViewController:self.leftSideBarViewController];
    [self addChildViewController:self.rightSideBarViewController];
    self.leftSideBarViewController.view.frame = self.navBackView.bounds;
    self.rightSideBarViewController.view.frame = self.navBackView.bounds;
    [self.navBackView addSubview:self.rightSideBarViewController.view];
    [self.navBackView addSubview:self.leftSideBarViewController.view];

    // init Gesture.
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    [self.contentView addGestureRecognizer:_panGestureRecognizer];
    
    
    self.leftSideBarViewController.view.backgroundColor = [UIColor redColor];
    self.rightSideBarViewController.view.backgroundColor = [UIColor greenColor];
    [self.view bringSubviewToFront:self.contentView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// protocol SideBarSelectedDelegate...
-(void) leftSideBarSelectWithController:(UIViewController*)controller
{
    
}

-(void) rightSideBarSelectWithController:(UIViewController*)controller
{
    
}

-(void) showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    if (direction!=SideBarShowDirectionNone) {
        UIView *view ;
        if (direction == SideBarShowDirectionLeft)
        {
            view = self.leftSideBarViewController.view;
        }else
        {
            view = self.rightSideBarViewController.view;
        }
        [self.navBackView bringSubviewToFront:view];
    }
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}

// Gesture...
- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        UIView *view ;
        if (translation+currentTranslate>0)
        {
            view = self.leftSideBarViewController.view;
        }else
        {
            view = self.rightSideBarViewController.view;
        }
        [self.navBackView bringSubviewToFront:view];
        
	} else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded)
    {
		currentTranslate = self.contentView.transform.tx;
        if (!sideBarShowing) {
            if (fabs(currentTranslate)<ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }else if(currentTranslate>ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }else
        {
            if (fabs(currentTranslate)<ContentOffset-ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                
            }else if(currentTranslate>ContentOffset-ContentMinOffset)
            {
                
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }
        
        
	}
    
}
- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

// Animation.
-(void) moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(-ContentOffset, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.navBackView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            sideBarShowing = NO;
            
            
        }else
        {
            [self contentViewAddTapGestures];
            sideBarShowing = YES;
        }
        currentTranslate = self.contentView.transform.tx;
	};
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
    
}

- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView   removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}

@end
