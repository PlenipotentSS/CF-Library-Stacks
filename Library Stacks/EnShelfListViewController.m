//
//  EnShelfListViewController.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/15/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import "EnShelfListViewController.h"
#import "Library.h"
#import "Shelf.h"

@implementation EnShelfListViewController

@synthesize objects = _objects;
@synthesize shelfDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissView:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

-(void) dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_objects count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.shelfDelegate respondsToSelector:@selector(dismissShelfOptionController:)])
    {
        [self.shelfDelegate dismissShelfOptionController: _objects[indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell2";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    Shelf *theShelf = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [theShelf getSection];
    
    return cell;
}

@end
