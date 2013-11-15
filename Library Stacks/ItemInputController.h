//
//  ItemInputController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "Shelf.h"

@protocol ItemInputDelegate <NSObject>
-(void) dismissItemInputController: (NSString *)saveObjectName;
@end

@interface ItemInputController : UIViewController

@property(nonatomic, assign) id<ItemInputDelegate> myInputDelegate;
@property(strong) NSString *navTitle;
@property(strong) UITextField *theTextField;
@property(strong) UITextField *secondTextField;
@property(strong) NSString *objectName;
@property BOOL addingABook;
@property(strong) Book *updateBookObject;
@property(strong) UIButton *unShelfBut;
@property(strong) UIButton *enShelfBut;


-(void) saveInfo:sender;
-(void) makeTextFields;
-(void) dismissView:(id)sender;
-(void) addShelvingOptions;
@end
