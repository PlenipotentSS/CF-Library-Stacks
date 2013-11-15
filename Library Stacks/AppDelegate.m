//
//  AppDelegate.m
//  Library Stacks
//
//  Created by Steven Stevenson on 11/14/13.
//  Copyright (c) 2013 Steven Stevenson. All rights reserved.
//

#import "AppDelegate.h"
//#import "TestFlight.h"
#import "MasterViewController.h"
#import "Library.h"
#import "Shelf.h"
#import "Book.h"

@implementation AppDelegate

/*
 *
 *
 *
 *
 *
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[TestFlight takeOff:@"a86439e2-9ce8-4156-90b9-d644b00b7182"];
    
    NSArray *sectionNames = @[@"Fiction",@"Non-Fiction",@"Children",@"Fantasy",@"Education"];
    NSArray *titles = @[@"Ender's Game", @"Lord of the Rings", @"Steve Jobs", @"Go Dog Go", @"Topics in Mathematical Models", @"Sherlock Homes",@"Charlotte's Web",@"I am Malala",@"The Help",@"Harry Potter"];
    NSArray *authors = @[@"Orson Scott Card",@"J.R.R. Toklien",@"Walter Isaacson",@"P.D. Eastman",@"K.K. Tung",@"Arthur Conan Doyle",@"E.B. White",@"Christina Lamb",@"Kathryn Stocket",@"J.K. Rowling"];
    
    //create the library with shelves by section names
    //NSLog (@"Creating Library with Shelves");
    Library *myLibrary = [[Library new] initWithShelfNames:sectionNames];
    [myLibrary setLibraryName:@"The Best Library"];
    
    //create the books from array
    //NSLog(@"Creating Books...");
    NSMutableArray *theBooks = [[NSMutableArray new] init];
    for (int i = 0; i <10; i++ ) {
        Book *thisBook = [[Book new] initWithTitle:[titles objectAtIndex:i] andAuthor:[authors objectAtIndex:i]];
        [theBooks addObject:thisBook];
    }
    
    //add books to shelves
    //NSLog (@"Putting Books on Shelves");
    [[theBooks objectAtIndex:0] enShelf:[[myLibrary getShelves] objectAtIndex:4]];
    [[theBooks objectAtIndex:1] enShelf:[[myLibrary getShelves] objectAtIndex:4]];
    [[theBooks objectAtIndex:2] enShelf:[[myLibrary getShelves] objectAtIndex:2]];
    [[theBooks objectAtIndex:3] enShelf:[[myLibrary getShelves] objectAtIndex:3]];
    [[theBooks objectAtIndex:4] enShelf:[[myLibrary getShelves] objectAtIndex:5]];
    [[theBooks objectAtIndex:5] enShelf:[[myLibrary getShelves] objectAtIndex:1]];
    [[theBooks objectAtIndex:6] enShelf:[[myLibrary getShelves] objectAtIndex:3]];
    [[theBooks objectAtIndex:7] enShelf:[[myLibrary getShelves] objectAtIndex:2]];
    [[theBooks objectAtIndex:8] enShelf:[[myLibrary getShelves] objectAtIndex:1]];
    [[theBooks objectAtIndex:9] enShelf:[[myLibrary getShelves] objectAtIndex:4]];
    
    NSMutableArray *libraries = [[NSMutableArray alloc] initWithArray: @[myLibrary]];
    
    UINavigationController * navController = (UINavigationController *) self.window.rootViewController;
    MasterViewController * masterController = [navController.viewControllers objectAtIndex:0];
    masterController.objects = libraries;
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
