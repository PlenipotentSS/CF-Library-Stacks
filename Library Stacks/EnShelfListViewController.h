//
//  EnShelfListViewController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/15/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//
//  Simple Table View Controller for Selecting which shelf
//  a book should be shelved to
//

#import <UIKit/UIKit.h>
#import "Shelf.h"

@protocol EnShelfListDelegate <NSObject>
-(void) dismissShelfOptionController: (Shelf *)chosenShelf;
@end

@interface EnShelfListViewController : UITableViewController {
    int offset;
}

@property(nonatomic, assign) id<EnShelfListDelegate> shelfDelegate;
@property (strong) NSMutableArray *objects;

@end
