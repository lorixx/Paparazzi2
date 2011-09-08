//
//  Paparazzi2AppDelegate.h
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright Northeastern University 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface Paparazzi2AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	UINavigationController *personListNavController;
	UINavigationController *recentsNavController;
	UITabBarController *tabBarController;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *personListNavController;
@property (nonatomic, retain) IBOutlet UINavigationController *recentsNavController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
-(void) populateCoreDataStorage;

@end

