//
//  ItemInputController.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemInputDelegate <NSObject>
-(void) dismissItemInputController: (NSString *)saveObjectName;
@end

@interface ItemInputController : UIViewController

@property(nonatomic, assign) id<ItemInputDelegate> myInputDelegate;
@property(strong) NSString *navTitle;
@property(strong) NSString *objectName;
@property(strong) UITextField *theTextField;
@property(strong) UITextField *secondTextField;
@property BOOL addingABook;
@property BOOL edittingObject;

-(void)saveInfo:sender;
@end
