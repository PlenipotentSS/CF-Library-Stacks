//
//  ItemInputController.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//
//  General View Controller for editing any of the objects.
//  This implementation can be customized given the object
//  wished to be updated.
//

#import "ItemInputController.h"
#import "MasterViewController.h"
#import "Library.h"
#import "AppDelegate.h"

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
 *  Setup ItemInputController
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
 *  declare textFields for controller, but does not attach to view, for
 *  purpose of data pre-load to current view controller
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
 *  Creates View controller for a list of shelves to select for enshelving
 *  book objects
 *
 *  Warning: Call only if object to be updated is of type Book
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
 *  method for button object to remove book from any shelf and inform
 *  user of action
 *
 */
-(void) takeBookOffShelf:(UIButton*)sender {
    [updateBookObject unShelf];
    [enShelfBut setAlpha:1.0];
    [unShelfBut setAlpha:.2];
    enShelfBut.enabled = YES;
    unShelfBut.enabled = NO;
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Book Removed From Shelf!" message:[NSString stringWithFormat:@"You've unshelved %@",[updateBookObject getTitle]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
}

/*
 *  method for button object to put on a shelf by create view controller
 *  to select which shelf
 *
 */
-(void) putBookOnShelf:(UIButton*)sender {
    [enShelfBut setAlpha:.2];
    [unShelfBut setAlpha:1.0];
    enShelfBut.enabled = NO;
    unShelfBut.enabled = YES;
    
    EnShelfListViewController  *shelfListController = [[EnShelfListViewController alloc] init];
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    shelfListController.objects = [[NSMutableArray alloc] initWithArray: del.topMasterController.objects];
    shelfListController.shelfDelegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: shelfListController];
    [[self navigationController] presentViewController:navigationController animated:YES completion:nil];
}

/*  @param chosenShelf is a Shelf* containing the shelf chosen for book object
 *  to be shelved (must be called via EnShelfListViewController protocol)
 *
 *  used to add Book to Shelf and inform user of action
 */
-(void) dismissShelfOptionController: (Shelf *)chosenShelf {
    [updateBookObject enShelf: chosenShelf];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Book Reshelved!" message:[NSString stringWithFormat:@"You've reshelved to %@",[chosenShelf getSection]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
}

/*
 *  setup on view load and attach labels and buttons according to how
 *  input view controller is being used
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
 *  sender method to dimiss current view
 *
 */
-(void) dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 *  Storing information before dismissal of view controller to save data
 *  for parent view controller.
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
 *  Memory cleanup of variables
 *
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
