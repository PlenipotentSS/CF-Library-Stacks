//
//  MasterViewController.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import "MasterViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"
#import "DetailViewController.h"

@implementation MasterViewController

@synthesize objects = _objects;

- (void)setDetailItems:(NSMutableArray*)newDetailItem
{
    if (_objects != newDetailItem) {
        _objects = newDetailItem;
    }
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    //self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    if ( [self.title isEqualToString:@"LibraryView"]) {
        Library *newLib = [[Library new] init];
        [newLib  setLibraryName:@"New Library"];
        [_objects insertObject:newLib atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if ( [self.title isEqualToString:@"ShelfView"]) {
        Shelf *newShelf = [[Shelf new] initWithSectionName: @"New Shelf"];
        [_objects insertObject:newShelf atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if ( [self.title isEqualToString:@"BookView"]) {
        Book *newBook = [[Book new] initWithTitle:@"New Title" andAuthor:@"New Author"];
        [_objects insertObject:newBook atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"Cell"];
    if ( [_objects[indexPath.row] isKindOfClass:[Library class]] ) {
        Library *lib = [_objects objectAtIndex:indexPath.row];
        cell.textLabel.text = [lib getLibraryName];
    } else if ( [_objects[indexPath.row] isKindOfClass:[Shelf class]] ) {
        Shelf *shelf = [_objects objectAtIndex:indexPath.row];
        cell.textLabel.text = [shelf getSection];
    } else if ( [_objects[indexPath.row] isKindOfClass:[Book class]] ) {
        Book *book = [_objects objectAtIndex:indexPath.row];
        cell.textLabel.text = [book getTitle];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                             bundle: nil];
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ( [_objects[indexPath.row] isKindOfClass:[Library class]] ) {
            Library *object = _objects[indexPath.row];
            MasterViewController *controller = (MasterViewController*)[mainStoryboard
                                                                       instantiateViewControllerWithIdentifier: @"ShelfView"];
            NSMutableArray *shelves = [[NSMutableArray alloc] initWithArray:[object getShelves]];
            
            controller.objects = shelves;
        } else if ( [_objects[indexPath.row] isKindOfClass:[Shelf class]] ) {
            Shelf *object = _objects[indexPath.row];
            MasterViewController *controller = (MasterViewController*)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier: @"BookView"];
            NSMutableArray *books = [[NSMutableArray alloc] initWithArray:[object getBooks]];
            controller.objects = books;
        } else if ( [_objects[indexPath.row] isKindOfClass:[Book class]] ) {
            Book *object = _objects[indexPath.row];
            DetailViewController *controller = (DetailViewController*)[mainStoryboard
                                                                       instantiateViewControllerWithIdentifier: @"DetailView"];
           controller.detailItem = object;
        }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showBookDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Book *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    } else if ([[segue identifier] isEqualToString:@"showBooks"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableArray *books = [[NSMutableArray alloc] initWithArray:[_objects[indexPath.row] getBooks]];
        [[segue destinationViewController] setDetailItems: books];
    }  else if ([[segue identifier] isEqualToString:@"showAllShelves"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableArray *shelves = [[NSMutableArray alloc] initWithArray:[_objects[indexPath.row] getShelves]];
        [[segue destinationViewController] setDetailItems: shelves];
    }
    
}

@end
