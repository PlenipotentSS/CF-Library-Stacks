//
//  editButton.h
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//
//  Extended class of UIButton to contain userdata for each button
//

#import <UIKit/UIKit.h>

@interface editButton : UIButton {
    id userData;
}

@property (nonatomic, readwrite, retain) id userData;

@end
