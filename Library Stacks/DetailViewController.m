//
//  DetailViewController.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//
//  The Leaf of the Library heirarchy that shows the book's information
//  as well as option for editing the information provided.
//

#import "DetailViewController.h"
#import "Book.h"


@implementation DetailViewController

@synthesize detailItem;
@synthesize previous_vc;
@synthesize detailDescriptionLabel;
@synthesize authorLabel;
@synthesize itemInputController;

/*
 *  @param newDetailItem:newDetailItem a Book object for viewing/editing
 *
 *  Adding initial object to be viewed in detail
 *
 */
- (void)setDetailItem:(Book*)newDetailItem {
    if (detailItem != newDetailItem) {
        detailItem = newDetailItem;
        
        [self configureView];
    }     
}


/*
 *  update label fields
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
 *  setup on view load
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self configureView];
}

/*
 *  If object is in edit mode, open input controller for update
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
 *  Data passed from finished updating object information
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
    
    [self updateBackShelf];
}

- (void) updateBackShelf {
    previous_vc.objects = [[NSMutableArray alloc] initWithArray: [[detailItem getLocation] getBooks]];
    previous_vc.title = [[detailItem getLocation] getSection];
}

/*
 *  Memory cleanup of variables
 *
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
