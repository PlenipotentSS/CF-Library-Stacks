//
//  MasterViewController.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//
//  The view controller that contains the structure of browsing
//  through the library.
//

#import "MasterViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"
#import "DetailViewController.h"


@implementation MasterViewController

@synthesize objects = _objects;
@synthesize parent;
@synthesize itemInputController;
@synthesize previous_vc;
@synthesize addedObjectName;
@synthesize editPath;
@synthesize updateNeeded;

/*
 *  @param newDetailItem:newDetailItem a NSMutable Array containing the list of
 *      for this level of browsing
 *  @param setDetailParent:newParent the parent object of the current list of
 *      objects
 *
 *  Adding initial variables for browsing
 *
 */
- (void)setDetailItems:(NSMutableArray*) newDetailItem setDetailParent: (NSObject*) newParent {
    if (_objects != newDetailItem) {
        _objects = newDetailItem;
    }
    if (parent != newParent) {
        parent = newParent;
    }
}

/*
 *  setup on view load
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

/*
 *  As TableView will appear, prepare table for update or otherwise
 *
 */
- (void)viewWillAppear:(BOOL)animated {
    if ( [_objects count] > 0 && [[_objects objectAtIndex:0] isKindOfClass:[Book class]]){
        previous_vc.objects = [[NSMutableArray alloc] initWithArray:[[[[_objects objectAtIndex:0] getLocation] getLocation] getShelves]];
        previous_vc.title = [[[[_objects objectAtIndex:0] getLocation] getLocation] getLibraryName];
    }
    [self.tableView reloadData];
}

/*
 *  Memory cleanup of variables
 *
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *  If add button was pressed, create input controller for new object
 *  variables
 *
 *  customized setup of input controller given if new input controller BOOl
 *  [addingABook] is true
 *
 */
- (void)insertNewObject:(id)sender {
    self.editPath = NULL;
    itemInputController = [[ItemInputController alloc] init];
    if ( [self.title isEqualToString:@"LibraryView"]) {
        itemInputController.navTitle = @"New Library";
    } else if ( [self.title isEqualToString:@"ShelfView"]) {
        itemInputController.navTitle = @"New Shelf";
    } else if ( [self.title isEqualToString:@"BookView"]) {
        itemInputController.navTitle = @"New Book";
        itemInputController.addingABook = YES;
    }
    itemInputController.myInputDelegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: itemInputController];
    [[self navigationController] presentViewController:navigationController animated:YES completion:nil];
}

/*  @param saveObjectName is a NSString* containing the updated or new
 *      object variables
 *  
 *  used only to add or edit variables returning from ItemInputController
 *  protocol
 *
 */
-(void) dismissItemInputController: (NSString *)saveObjectName {
    if ( self.editPath ) {
        if ( [_objects[self.editPath.row] isKindOfClass:[Library class]] ) {
            [(Library*)_objects[self.editPath.row] setLibraryName:saveObjectName];
        } else if ( [_objects[self.editPath.row] isKindOfClass:[Shelf class]] ) {
            [(Shelf*)_objects[self.editPath.row] setSection:saveObjectName];
        }
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.editPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        self.editPath = NULL;
    } else {
        self.addedObjectName = saveObjectName;
        [self addObjectData];
    }

}

/*
 *  Adds objects with data stored in self.addedObjectName - suggested to
 *  implicitly set self.addedObjectName with information before calling
 *  addObjectData method
 *
 */
- (void) addObjectData {
    NSString *objectName = self.addedObjectName;
    if (!objectName) {
        objectName = @"Untitled";
    }
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    if ( [self.title isEqualToString:@"LibraryView"]) {
        Library *newLib = [[Library new] init];
        [newLib  setLibraryName:objectName];
        [_objects insertObject:newLib atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
    } else if ( [self.title isEqualToString:@"ShelfView"]) {
        Shelf *newShelf = [[Shelf new] initWithSectionName: objectName];
        [newShelf setLocation: (Library*)parent];
        [(Library*)parent addShelf: newShelf];
        [_objects insertObject:newShelf atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
    } else if ( [self.title isEqualToString:@"BookView"]) {
        NSString *bookTitle = @"New Title";
        NSString *bookAuthor = @"New Author";
        if ([objectName rangeOfString:@"|"].location != NSNotFound){
            NSArray *bookDetails = [objectName componentsSeparatedByString:@"|"];
            bookTitle = [bookDetails objectAtIndex:1];
            bookAuthor = [bookDetails objectAtIndex:0];
        }
        Book *newBook = [[Book new] initWithTitle:bookTitle andAuthor:bookAuthor];
        [newBook enShelf: (Shelf*)parent];
        [_objects insertObject:newBook atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    [self.tableView reloadData];
    
}

/*
 *  returns only this section of objects
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/*
 *  returns the count of _objects in current object
 *
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

/*
 *  puts object information in table view cell and adds edit button
 *  for parent objects created by data for library
 *
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if ( [_objects[indexPath.row] isKindOfClass:[Book class]] ) {
        Book *book = [_objects objectAtIndex:indexPath.row];
        cell.textLabel.text = [book getTitle];
    } else {
    
        CGRect cellRect = [cell bounds];
        CGFloat cellHeight = cellRect.size.height;
        
        UIImage *btnImage = [UIImage imageNamed:@"edit.png"];
        
        editButton *editBut = [[editButton alloc] initWithFrame:CGRectMake(10, (cellHeight/2)-10, 20, 20)];
        [editBut setImage:btnImage forState:UIControlStateNormal];
        
        [editBut setUserData: indexPath];
        [editBut addTarget:self action:@selector(editButtonPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
        if (![_objects[indexPath.row] isKindOfClass:[Shelf class]] || ![[_objects[indexPath.row] getSection] isEqualToString:@"Unshelved Books"]) {
            [cell addSubview:editBut];
        }
            
        cell.indentationWidth = 30;
        if ( [_objects[indexPath.row] isKindOfClass:[Library class]] ) {
            Library *lib = [_objects objectAtIndex:indexPath.row];
            cell.textLabel.text = [lib getLibraryName];
        } else if ( [_objects[indexPath.row] isKindOfClass:[Shelf class]] ) {
            Shelf *shelf = [_objects objectAtIndex:indexPath.row];
            cell.textLabel.text = [shelf getSection];
        }
    }
    return cell;
}

/*
 *  Edit Button on object cell is pressed and opens input controller
 *  for updating the object
 *
 */
-(void) editButtonPressed:(editButton*)sender {
    itemInputController = [[ItemInputController alloc] init];
    
    NSIndexPath *thePath = sender.userData;
    self.editPath = thePath;
    
    if ( [self.title isEqualToString:@"LibraryView"]) {
        itemInputController.navTitle = @"Update Library";
        itemInputController.theTextField.text = [(Library*)_objects[thePath.row] getLibraryName];
    } else if ( [self.title isEqualToString:@"ShelfView"]) {
        itemInputController.navTitle = @"Update Shelf";
        itemInputController.theTextField.text = [(Shelf*)_objects[thePath.row] getSection];
    }
    itemInputController.myInputDelegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: itemInputController];
    [[self navigationController] presentViewController:navigationController animated:YES completion:nil];
}

/*
 *  Rows can be edited at indexpath!
 *
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
 *  Only used for Deleting cells from the list
 *
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ( [[_objects objectAtIndex:indexPath.row] isKindOfClass:[Shelf class]]) {
            Shelf *delShelf = [_objects objectAtIndex:indexPath.row];
            [[delShelf getLocation] removeShelf:delShelf];
        } else if ( [[_objects objectAtIndex:indexPath.row] isKindOfClass:[Book class]]) {
            Book *deleteBook = [_objects objectAtIndex:indexPath.row];
            [deleteBook destroyBook];
        }
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
 *  Using Storyboard segue names, provide object information for the next
 *  view controller
 *
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showBookDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Book *object = _objects[indexPath.row];
        [[segue destinationViewController] setPrevious_vc:self];
        [[segue destinationViewController] setDetailItem:object];
        UINavigationItem *theNav = [[segue destinationViewController] navigationItem];
        theNav.title = [_objects[indexPath.row] getTitle];
        updateNeeded = YES;
    } else if ([[segue identifier] isEqualToString:@"showBooks"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableArray *books = [[NSMutableArray alloc] initWithArray:[_objects[indexPath.row] getBooks]];
        [[segue destinationViewController] setDetailItems:books setDetailParent: _objects[indexPath.row]];
        [[segue destinationViewController] setPrevious_vc:self];
        UINavigationItem *theNav = [[segue destinationViewController] navigationItem];
        theNav.title = [_objects[indexPath.row] getSection];
    }  else if ([[segue identifier] isEqualToString:@"showAllShelves"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableArray *shelves = [[NSMutableArray alloc] initWithArray:[_objects[indexPath.row] getShelves]];
        [[segue destinationViewController] setDetailItems:shelves setDetailParent: _objects[indexPath.row]];
        [[segue destinationViewController] setPrevious_vc:self];
        UINavigationItem *theNav = [[segue destinationViewController] navigationItem];
        theNav.title = [_objects[indexPath.row] getLibraryName];
    }
}

@end
