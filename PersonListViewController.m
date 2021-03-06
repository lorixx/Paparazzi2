//
//  PersonListViewController.m
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright 2011 Northeastern University. All rights reserved.
//

#import "PersonListViewController.h"
#import "PhotoListViewController.h"
#import "FlickrFetcher.h"
#import "Person.h"
#import "Photo.h"

@implementation PersonListViewController


@synthesize personsArray;
@synthesize fetchedResultsController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.fetchedResultsController = 
	[[FlickrFetcher sharedInstance] fetchedResultsControllerForEntity:@"Person" withPredicate: nil]; 
	
	/** 
	 *  This is very important before we use the data, we need to perform fetch to get data from the database, otherwise
	 *  these will be no data to use
	 */
	NSError *error;
	if(![self.fetchedResultsController performFetch:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}

	
	NSLog(@"the first count: %d", [[self.fetchedResultsController sections] count]);
	
	int count = [[[FlickrFetcher sharedInstance] fetchManagedObjectsForEntity:@"Person" withPredicate: nil] count]; 
	NSLog(@"the second count for objects %d", count);

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
	 self.navigationItem.title = @"All Contacts";
	
	UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Contacts" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	NSLog(@"returns here %d",[[self.fetchedResultsController sections] count]);
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return [[[FlickrFetcher sharedInstance] fetchManagedObjectsForEntity:@"Person" withPredicate: nil] count];
	id <NSFetchedResultsSectionInfo> sectionInfo =
	[[self.fetchedResultsController sections] objectAtIndex:section];
	
	
	NSLog(@"returns here here %d",[sectionInfo numberOfObjects] );
	return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"this person");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // Configure the cell...
	
	Person *thisPerson = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	NSLog(@"this person: %@", [ thisPerson valueForKey:@"name"]);

	cell.textLabel.text =[ thisPerson valueForKey:@"name"];	
	Photo * anyPhoto = [[thisPerson valueForKey:@"photos" ] anyObject];
	[cell.imageView setImage:[UIImage imageNamed: [anyPhoto valueForKey:@"imageURL"]]];
	cell.detailTextLabel.text = [anyPhoto valueForKey:@"imageName"];
	
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



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




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	Person *newPerson = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSLog(@"print the name %@", [newPerson name]);
		
	PhotoListViewController *photoListViewController = [[PhotoListViewController alloc] initWithPerson:newPerson ];

	// ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:photoListViewController animated:YES];
	 [photoListViewController release];
	 
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

