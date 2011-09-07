//
//  Paparazzi2AppDelegate.m
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright Northeastern University 2011. All rights reserved.
//

#import "Paparazzi2AppDelegate.h"
#import "PersonListViewController.h"
#import "PhotoListViewController.h"
#import "Person.h"
#import "Photo.h"
#import "FlickrFetcher.h"

@implementation Paparazzi2AppDelegate

@synthesize window;
@synthesize personListNavController;
@synthesize recentsNavController;
@synthesize tabBarController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.
	
	
	//start reading from plist and save context to database
	//NSManagedObjectContext *MOC = [self managedObjectContext];
	if ([[FlickrFetcher sharedInstance] databaseExists]) {
		;
	}
	NSManagedObjectContext *MOC = [[FlickrFetcher sharedInstance] managedObjectContext];
	/*
	Person *james = [NSEntityDescription
					 insertNewObjectForEntityForName:@"Person" inManagedObjectContext:MOC];
	[james setValue:@"James" forKey:@"name"];
	
	Photo *jp1 = [NSEntityDescription
				  insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:MOC];
	[jp1 setValue:@"photo 1" forKey:@"imageName"];
	[jp1 setValue:@"photo1.jpg" forKey:@"imageURL"];
	[jp1 setValue:james forKey:@"whoTook"];
	
	Photo *jp2 = [NSEntityDescription
				  insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:MOC];
	[jp2 setValue:@"photo 2" forKey:@"imageName"];
	[jp2 setValue:@"photo2.jpg" forKey:@"imageURL"];
	[jp2 setValue:james forKey:@"whoTook"];
	
	
	Person *ken = [NSEntityDescription
				   insertNewObjectForEntityForName:@"Person" inManagedObjectContext:MOC];
	[ken setValue:@"Ken" forKey:@"name"];
	
	Photo *kp1 = [NSEntityDescription
			   insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:MOC];
	[kp1 setValue:@"photo 3" forKey:@"imageName"];
	[kp1 setValue:@"photo3.jpg" forKey:@"imageURL"];
	[kp1 setValue:ken forKey:@"whoTook"];
	
	Photo *kp2 = [NSEntityDescription
				  insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:MOC];
	[kp2 setValue:@"photo 2" forKey:@"imageName"];
	[kp2 setValue:@"photo2.jpg" forKey:@"imageURL"];
	[kp2 setValue:ken forKey:@"whoTook"];
	*/
	
	self = [super init];
	if(self) {
		/*NSString *errorDesc = nil;
		NSPropertyListFormat format;
		NSString *plistPath;
		NSString *rootPath = 
		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		plistPath = @"FakeData.plist";
		
		if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
			plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
		}
		
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
		NSArray *temp = (NSArray *)[NSPropertyListSerialization
											  propertyListFromData:plistXML 
											  mutabilityOption:NSPropertyListMutableContainersAndLeaves 
											  format:&format 
											  errorDescription:&errorDesc];
		if(!temp){
			NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
		}*/
		
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"FakeData" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:path];
		NSString *error;
		NSPropertyListFormat format;
		id plist;
		
		plist = [NSPropertyListSerialization propertyListFromData:plistData
												 mutabilityOption:NSPropertyListImmutable
														   format:&format
												 errorDescription:&error];
		if(!plist){
			NSLog(error);
			[error release];
		}
		
		NSMutableArray *dma = (NSMutableArray *)[NSPropertyListSerialization
												 propertyListFromData:plistData
												 mutabilityOption:NSPropertyListMutableContainersAndLeaves
												 format:&format
												 errorDescription:&error];
		
		for( int i = 0; i < [dma count]; i++){
			
			//ToDo: first check if photo exist, then check if person exist, add relation then update.
			
			
			NSDictionary *thisDict = (NSDictionary *) [dma objectAtIndex:i];
			NSLog(@"this has %@ , %@", [thisDict objectForKey:@"user"], [thisDict objectForKey:@"name"]);
			
			
			NSString *personName = (NSString *)[thisDict objectForKey:@"user"];
			
			NSEntityDescription *entityDescription = [NSEntityDescription
													  entityForName:@"Person" inManagedObjectContext:MOC];
			NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
			[request setEntity:entityDescription];
			
			// Set example predicate and sort orderings...
			//NSNumber *minimumSalary = ...;
			NSPredicate *predicate = [NSPredicate predicateWithFormat:
									  @"name == %@", personName];
			[request setPredicate:predicate];
			
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
												initWithKey:@"name" ascending:YES];
			[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
			[sortDescriptor release];
			
			NSError *error = nil;
			NSArray *array = [MOC executeFetchRequest:request error:&error];
			if (array == nil)
			{
				// Deal with error...
			}
			if([array count] > 0){
				NSLog(@"has something");
				Person *thisPerson = (Person *)[array objectAtIndex:0];
				thisPerson 
				
				
			} else {
				Person *tempPerson = [NSEntityDescription
									  insertNewObjectForEntityForName:@"Person" inManagedObjectContext:MOC];
				[tempPerson setValue:(NSString *)[thisDict objectForKey:@"user"] forKey:@"name"];
				
			}

			
			
			
			
			
			Photo *tempPhoto = [NSEntityDescription
						  insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:MOC];
			[tempPhoto setValue:(NSString *)[thisDict objectForKey:@"name"] forKey:@"imageName"];
			[tempPhoto setValue:(NSString *)[thisDict objectForKey:@"path"] forKey:@"imageURL"];
			[tempPhoto setValue:tempPerson forKey:@"whoTook"];
			
			
		}
		
		
		
		//NSLog( temp objectForKey: @
	}	
	

	NSError *error;
	if(![MOC save:&error]){
		NSLog(@"oh, couldnt save: %@", [error localizedDescription]);
	}
	
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription
								   entityForName:@"Person" inManagedObjectContext:MOC];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [MOC executeFetchRequest:fetchRequest error:&error];
	
	
	for (NSManagedObject *info in fetchedObjects){
		NSLog(@"Name: %@", [info valueForKey:@"name"]);
		
		NSSet *set = [info valueForKey:@"photos"];
		NSEnumerator *enumerator = [set objectEnumerator];
		id collectionMember;
		while (collectionMember = [enumerator nextObject]) {
			NSLog(@"%@ has: %@",[info valueForKey:@"name"], [collectionMember valueForKey:@"imageName"]);
		}
		
		/*
		NSLog(@"image name: %@", [info valueForKey:@"imageName"]);
		NSManagedObject *photographer = [info valueForKey:@"whoTook"];
		NSLog(@"who took: %@", [photographer valueForKey:@"name"]);
		 */
	} 
	
	
	[fetchRequest release];
	
	
	self.tabBarController = [[UITabBarController alloc] init];
	PersonListViewController *personListVC = [[PersonListViewController alloc]init];
	PhotoListViewController *recentPhotoListVC = [[PhotoListViewController alloc] init];
	
	self.personListNavController = [[UINavigationController alloc] init];
	[personListNavController pushViewController:personListVC animated:NO];
	personListNavController.tabBarItem.title = @"Contacts";
	personListNavController.tabBarItem.image = [UIImage imageNamed:@"all.png"];
	
	self.recentsNavController = [[UINavigationController alloc] init];
	recentsNavController.tabBarItem.title = @"Recent";
	recentsNavController.tabBarItem.image = [UIImage imageNamed:@"faves.png"];
	[recentsNavController pushViewController:recentPhotoListVC animated:YES];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:personListNavController, recentsNavController, nil];
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
	[personListVC release];
	[recentPhotoListVC release];
	
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Paparazzi2" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Paparazzi2.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
	[tabBarController release];
	[personListNavController release];
	[recentsNavController release];
	
    [window release];
    [super dealloc];
}


@end

