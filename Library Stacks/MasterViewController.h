//
//  MasterViewController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong) NSMutableArray *objects;
@property(strong) NSObject *parent;

- (void)setDetailItems:(NSMutableArray*)newDetailItem setDetailParent: (NSObject*) newParent;
@end
