//
//  EnShelfListViewController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/15/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shelf.h"

@protocol EnShelfListDelegate <NSObject>
-(void) dismissShelfOptionController: (Shelf *)chosenShelf;
@end

@interface EnShelfListViewController : UITableViewController

@property(nonatomic, assign) id<EnShelfListDelegate> shelfDelegate;
@property (strong) NSMutableArray *objects;

@end
