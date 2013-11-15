//
//  DetailViewController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "ItemInputController.h"

@interface DetailViewController : UIViewController <ItemInputDelegate>

@property (strong, nonatomic) Book *detailItem;
@property(strong) ItemInputController *itemInputController;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

- (void)setDetailItem:(Book*)newDetailItem;
@end
