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

	if ([[FlickrFetcher sharedInstance] databaseExists]) {
		;
	}
	NSManagedObjectContext *MOC = [[FlickrFetcher sharedInstance] managedObjectContext];

	if(self) {
		[self populateCoreDataStorage];
	
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



- (void) populateCoreDataStorage {
	FlickrFetcher * flickrFetcher = [FlickrFetcher sharedInstance];
	
	NSLog(@"No Database created yet: Load plist!");
	NSManagedObjectContext*  flickrContext = [flickrFetcher managedObjectContext];
	
	//Get path to copy the Bundle to the Documents directory...
	NSString *rootPath = [self applicationDocumentsDirectory];
	NSString *plistPath = [rootPath stringByAppendingPathComponent:@"FakeData.plist"];
	
	//Pull the data from the Bundle object in the Resources directory...
	NSFileManager *defaultFile = [NSFileManager defaultManager];
	BOOL isInstalled = [defaultFile fileExistsAtPath :plistPath];
	
	NSArray *plistData = [NSArray arrayWithContentsOfFile :plistPath];
	
	if(isInstalled == NO)
	{		
		NSLog(@"Initial installation: retrieve and copy FakeData.plist from Main Bundle");
		
		NSString *bundlePath = [[NSBundle mainBundle] pathForResource :@"FakeData" ofType:@"plist"];
		plistData = [NSArray arrayWithContentsOfFile :bundlePath];
		
		if(plistData)
		{
			[plistData writeToFile :plistPath atomically:YES];
			//OR... [defaultFile copyItemAtPath:bundlePath toPath:plistPath error:&errorDesc];
		}		
	}
	
	//Process plistData to store in Photo and Person objects...
	NSEnumerator *enumr = [plistData objectEnumerator];
	id curr = [enumr nextObject];
	NSMutableArray *names = [[NSMutableArray alloc] init];
	
	while (curr != nil)
	{
		Photo *photo = [NSEntityDescription insertNewObjectForEntityForName :@"Photo" 
													  inManagedObjectContext:flickrContext];
		[photo setImageName :[curr objectForKey:@"name"]];
		[photo setImageURL :[curr objectForKey:@"path"]];
		
		//See if the name has already been set for a Person object...
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ IN %@", [curr objectForKey:@"user"], names];
		BOOL doesExist = [predicate evaluateWithObject :curr];
		
		if (doesExist == NO)
		{				
			Person *person = [NSEntityDescription insertNewObjectForEntityForName :@"Person" inManagedObjectContext:flickrContext];
			
			[person setName:[curr objectForKey:@"user"]];
			[person addPhotosObject:photo];
			[photo setWhoTook:person];
			NSLog(@"Person OBJECT: %@", person);
			[names addObject :[curr objectForKey :@"user"]];
		}
		else 
		{
			NSArray *objectArray = [flickrFetcher fetchManagedObjectsForEntity :@"Person" withPredicate:predicate];
			Person *person = [objectArray objectAtIndex:0];
			[photo setWhoTook:person];
			[objectArray release];
		}
		curr = [enumr nextObject];
	}
	[names release];
	
	
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

