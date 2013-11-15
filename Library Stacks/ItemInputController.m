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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navTitle = @"Add Object";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveInfo:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    theTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-20, 200, 40)];
    theTextField.textAlignment = NSTextAlignmentCenter;
    [theTextField setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:theTextField];
    
    if (self.addingABook){
        UILabel *bookTitle = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-50, 200, 40)];
        bookTitle.textAlignment = NSTextAlignmentCenter;
        bookTitle.text = @"Author:";
        [self.view addSubview:bookTitle];
        
        
        UILabel *bookAuthor = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-130, 200, 40)];
        bookAuthor.textAlignment = NSTextAlignmentCenter;
        bookAuthor.text = @"Title:";
        [self.view addSubview:bookAuthor];
        
        secondTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-100, 200, 40)];
        secondTextField.textAlignment = NSTextAlignmentCenter;
        [secondTextField setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:secondTextField];
    } else {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-100, (screenHeight/2)-50, 200, 40)];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.text = @"Name:";
        [self.view addSubview:myLabel];

    }
    

}


-(void)saveInfo:sender {
    if([self.myInputDelegate respondsToSelector:@selector(dismissItemInputController:)])
    {
        if (secondTextField.text) {
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
