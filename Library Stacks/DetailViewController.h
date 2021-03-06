//
//  DetailViewController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//
//  The Leaf of the Library heirarchy that shows the book's information
//  as well as option for editing the information provided.
//


#import <UIKit/UIKit.h>
#import "Book.h"
#import "ItemInputController.h"
#import "MasterViewController.h"

@interface DetailViewController : UIViewController <ItemInputDelegate>

@property (strong, nonatomic) Book *detailItem;
@property (strong, nonatomic) MasterViewController *previous_vc;
@property(strong) ItemInputController *itemInputController;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

- (void)setDetailItem:(Book*)newDetailItem;
- (void)setPrevious_vc:(MasterViewController *)pre_vc;
- (void) updateBackShelf;
@end
