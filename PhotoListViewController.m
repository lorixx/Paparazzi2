//
//  PhotoListViewController.m
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright 2011 Northeastern University. All rights reserved.
//

#import "PhotoListViewController.h"
#include "PhotoDetailViewController.h"
#include "FlickrFetcher.h"
#import "Photo.h"


@implementation PhotoListViewController

@synthesize person;
@synthesize fetchedResultsController;


#pragma mark -
#pragma mark View lifecycle

- initWithPerson: (Person *)thisPerson
{
	self.person = thisPerson;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", thisPerson];
	
	
	self.fetchedResultsController =
	[[FlickrFetcher sharedInstance] fetchedPhotoResultsControllerForEntity:@"Photo" withPredicate:predicate ];
	 
	NSError *error;
	if(![self.fetchedResultsController performFetch:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	
	
	NSLog(@"Count for photos: %d", [[self.fetchedResultsController sections] count]);
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"All Photos";
	
	UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Photos" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
	
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	

	

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo =
		[[self.fetchedResultsController sections] objectAtIndex:section];
	
	return [sectionInfo numberOfObjects];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	Photo *thisPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [thisPhoto valueForKey:@"imageName"];
	[cell.imageView setImage:[UIImage imageNamed:[thisPhoto valueForKey:@"imageURL"]]];
	cell.detailTextLabel.text = @"Click me to view photo";
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	Photo *thisPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];

	PhotoDetailViewController *photoDetailViewController = [[PhotoDetailViewController alloc] initWithPhoto:thisPhoto];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:photoDetailViewController animated:YES];
	 [photoDetailViewController release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

