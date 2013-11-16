//
//  EnShelfListViewController.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/15/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//
//  Simple Table View Controller for Selecting which shelf
//  a book should be shelved to
//

#import "EnShelfListViewController.h"
#import "Library.h"
#import "Shelf.h"

@implementation EnShelfListViewController

@synthesize objects = _objects;
@synthesize shelfDelegate;

/*
 *  Initial setup of view controller to select Shelf for enshelf.
 *  Sets offset to 1 to remove Unshelved Books from possible selction
 *
 */
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        offset = 1;
    }
    return self;
}

/*
 *  setup view on load
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/*
 *  returns only this section of objects
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_objects count];
}

/*
 *  returns the count of shelves in _objects (less Unshelved Books)
 *
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_objects objectAtIndex:section] getShelves] count]-offset;
}

/*
 *  gives the names of the sections (this case Library Names)
 *
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[_objects objectAtIndex:section] getLibraryName];
}

/*
 *  Selects the current row cell and saves to self.shelfDelegate for object retreival in
 *  linked protocol controller method
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.shelfDelegate respondsToSelector:@selector(dismissShelfOptionController:)])
    {
        [self.shelfDelegate dismissShelfOptionController: [[[_objects objectAtIndex:indexPath.section] getShelves] objectAtIndex:indexPath.row+offset]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*
 *  puts shelf information in table view cell for selection
 *
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    Library *thisLibrary = [_objects objectAtIndex:indexPath.section];
    Shelf *theShelf = [[thisLibrary getShelves] objectAtIndex:(indexPath.row+offset)];
    cell.textLabel.text = [theShelf getSection];
    
    return cell;
}

/*
 *  Memory Cleanup
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
