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
@synthesize edittingObject;

-(id)init {
    self = [super init];
    if (self) {
        self.navTitle = @"Add Object";
        
        [self makeTextFields];
            }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) makeTextFields {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.theTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-20, 200, 40)];
    self.secondTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-100, 200, 40)];

}

- (void)viewDidLoad
{
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
    
    if (self.addingABook){
        UILabel *bookTitle = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-60, 200, 40)];
        bookTitle.textAlignment = NSTextAlignmentCenter;
        bookTitle.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        bookTitle.text = @"Author:";
        [self.view addSubview:bookTitle];
        
        
        UILabel *bookAuthor = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-140, 200, 40)];
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

-(void) dismissView:sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)saveInfo:sender {
    if([self.myInputDelegate respondsToSelector:@selector(dismissItemInputController:)])
    {
        if (addingABook) {
            [self.myInputDelegate dismissItemInputController:[NSString stringWithFormat:@"%@|%@", theTextField.text, secondTextField.text]];
        } else {
            [self.myInputDelegate dismissItemInputController:theTextField.text];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
