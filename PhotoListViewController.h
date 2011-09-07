//
//  PhotoListViewController.h
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright 2011 Northeastern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"


@interface PhotoListViewController : UITableViewController {
	
	Person *person;
	NSFetchedResultsController *fetchedResultsController;


}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) Person *person;

-initWithPerson: (Person *)thisPerson ;

@end
