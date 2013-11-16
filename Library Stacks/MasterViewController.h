//
//  MasterViewController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//
//  The view controller that contains the structure of browsing
//  through the library.
//

#import <UIKit/UIKit.h>
#import "ItemInputController.h"
#import "editButton.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <ItemInputDelegate> {
    NSIndexPath *editPath;
}

@property (strong) NSMutableArray *objects;
@property(strong) NSObject *parent;
@property(strong) NSString *addedObjectName;
@property(strong) ItemInputController *itemInputController;
@property (strong, nonatomic) MasterViewController *previous_vc;
@property(strong) NSIndexPath *editPath;
@property BOOL updateNeeded;

- (void) addObjectData;
- (void) setDetailItems:(NSMutableArray*)newDetailItem setDetailParent: (NSObject*) newParent;
- (void) insertNewObject:(id)sender;
-(void) editButtonPressed:(editButton*)sender;
-(void) dismissItemInputController: (NSString *)saveObjectName;
@end
