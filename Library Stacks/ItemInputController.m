//
//  ItemInputController.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import "ItemInputController.h"
#import "MasterViewController.h"

@implementation ItemInputController

@synthesize navTitle;
@synthesize myInputDelegate;
@synthesize objectName;
@synthesize theTextField;
@synthesize secondTextField;
@synthesize addingABook;
@synthesize updateBookObject;
@synthesize unShelfBut;
@synthesize enShelfBut;

/*
 *
 *
 *
 *
 *
 */
-(id)init {
    self = [super init];
    if (self) {
        self.navTitle = @"Add Object";
        
        [self makeTextFields];
            }
    
    return self;
}

/*
 *
 *
 *
 *
 *
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 *
 *
 *
 *
 *
 */
-(void) makeTextFields {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.theTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-20, 200, 40)];
    self.secondTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-100, 200, 40)];

}

/*
 *
 *
 *
 *
 *
 */
-(void) addShelvingOptions {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    

    unShelfBut = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth*2/3)-50, 70, 100, 40)];
    [unShelfBut setTitle:@"UN-Shelf" forState:UIControlStateNormal];
    [unShelfBut addTarget:self action:@selector(takeBookOffShelf:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    enShelfBut = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/3)-50, 70, 100, 40)];
    [enShelfBut setTitle:@"EN-Shelf" forState:UIControlStateNormal];
    [enShelfBut addTarget:self action:@selector(putBookOnShelf:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [enShelfBut setBackgroundColor:[UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3]];
    [unShelfBut setBackgroundColor:[UIColor colorWithRed:0.9 green:0.2 blue:0.5 alpha:0.3]];

    if ([updateBookObject getLocation] && ![[[updateBookObject getLocation] getSection] isEqualToString:@"Unshelved Books"]) {

        [enShelfBut setAlpha:.2];
        enShelfBut.enabled = NO;
    } else {
        [unShelfBut setAlpha:.2];
        unShelfBut.enabled = NO;
    }
    [self.view addSubview:unShelfBut];
    [self.view addSubview:enShelfBut];
}

/*
 *
 *
 *
 *
 *
 */
-(void) takeBookOffShelf:(UIButton*)sender {
    [updateBookObject unShelf];
    [enShelfBut setAlpha:1.0];
    [unShelfBut setAlpha:.2];
    enShelfBut.enabled = YES;
    unShelfBut.enabled = NO;
}

/*
 *
 *
 *
 *
 *
 */
-(void) putBookOnShelf:(UIButton*)sender {
    //[updateBookObject enShelf:];
    [enShelfBut setAlpha:.2];
    [unShelfBut setAlpha:1.0];
    enShelfBut.enabled = NO;
    unShelfBut.enabled = YES;
}

/*
 *
 *
 *
 *
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveInfo:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissView:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    theTextField.textAlignment = NSTextAlignmentCenter;
    [theTextField setBackgroundColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:0.3]];
    [self.view addSubview:theTextField];
    
    if (self.addingABook || updateBookObject){
        UILabel *bookTitle = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-50, 200, 40)];
        bookTitle.textAlignment = NSTextAlignmentCenter;
        bookTitle.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        bookTitle.text = @"Author:";
        [self.view addSubview:bookTitle];
        
        
        UILabel *bookAuthor = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-130, 200, 40)];
        bookAuthor.textAlignment = NSTextAlignmentCenter;
        bookAuthor.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        bookAuthor.text = @"Title:";
        [self.view addSubview:bookAuthor];
        
        secondTextField.textAlignment = NSTextAlignmentCenter;
        [secondTextField setBackgroundColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:0.3]];
        [self.view addSubview:secondTextField];
    } else {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-60, 200, 40)];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        myLabel.text = @"Name:";
        [self.view addSubview:myLabel];

    }
    

}

/*
 *
 *
 *
 *
 *
 */
-(void) dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 *
 *
 *
 *
 *
 */
-(void)saveInfo:sender {
    if([self.myInputDelegate respondsToSelector:@selector(dismissItemInputController:)])
    {
        if (addingABook || updateBookObject) {
            [self.myInputDelegate dismissItemInputController:[NSString stringWithFormat:@"%@|%@", theTextField.text, secondTextField.text]];
        } else {
            [self.myInputDelegate dismissItemInputController:theTextField.text];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 *
 *
 *
 *
 *
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
