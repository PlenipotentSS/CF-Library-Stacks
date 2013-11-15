//
//  DetailViewController.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import "DetailViewController.h"
#import "Book.h"


@implementation DetailViewController

@synthesize detailItem;
@synthesize detailDescriptionLabel;
@synthesize authorLabel;
@synthesize itemInputController;

/*
 *
 *
 *
 *
 *
 */
- (void)setDetailItem:(Book*)newDetailItem {
    if (detailItem != newDetailItem) {
        detailItem = newDetailItem;
        
        NSLog(@"%@",[[detailItem getLocation] getSection]);
        [self configureView];
    }     
}

/*
 *
 *
 *
 *
 *
 */
- (void)configureView {
    if ([[self detailItem] isKindOfClass:[Book class]]) {
        self.detailDescriptionLabel.text = [self.detailItem getTitle];
        self.authorLabel.text = [self.detailItem getAuthor];
    } else {
        self.detailDescriptionLabel.text = @"Title Not Found";
        self.authorLabel.text = @"Author Not Found";
    }
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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self configureView];
}

/*
 *
 *
 *
 *
 *
 */
-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        itemInputController = [[ItemInputController alloc] init];
        
        itemInputController.navTitle = @"Edit Book";
        itemInputController.theTextField.text = [detailItem getAuthor];
        itemInputController.secondTextField.text = [detailItem getTitle];
        itemInputController.updateBookObject = detailItem;
        [itemInputController addShelvingOptions];
        [itemInputController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
        itemInputController.myInputDelegate = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: itemInputController];
        [[self navigationController] presentViewController:navigationController animated:YES completion:nil];
        [super setEditing:NO animated:NO];
    }
}

/*
 *
 *
 *
 *
 *
 */
-(void) dismissItemInputController: (NSString *)saveObjectName {
    
    NSString *bookTitle = [self.detailItem getTitle];
    NSString *bookAuthor = [self.detailItem getAuthor];
    if ([saveObjectName rangeOfString:@"|"].location != NSNotFound){
        NSArray *bookDetails = [saveObjectName componentsSeparatedByString:@"|"];
        bookTitle = [bookDetails objectAtIndex:1];
        bookAuthor = [bookDetails objectAtIndex:0];
    }
    [self.detailItem setTitle: bookTitle];
    [self.detailItem setAuthor: bookAuthor];
    self.detailDescriptionLabel.text = bookTitle;
    self.authorLabel.text = bookAuthor;
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
}

@end
