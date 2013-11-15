//
//  MasterViewController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInputController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <ItemInputDelegate>

@property (strong) NSMutableArray *objects;
@property(strong) NSObject *parent;
@property(strong) NSString *addedObjectName;
@property(strong) ItemInputController *itemInputController;

- (void) addObjectData;
- (void)setDetailItems:(NSMutableArray*)newDetailItem setDetailParent: (NSObject*) newParent;
@end
