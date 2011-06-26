//
//  PersonListViewController.h
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright 2011 Northeastern University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PersonListViewController : UITableViewController {
	NSMutableArray *personsArray;
	
	NSFetchedResultsController *fetchedResultsController;

}
@property (nonatomic, retain) NSMutableArray *personsArray;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
