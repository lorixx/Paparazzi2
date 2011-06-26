//
//  Person.h
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright 2011 Northeastern University. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Person :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* photos;

@end


@interface Person (CoreDataGeneratedAccessors)
- (void)addPhotosObject:(NSManagedObject *)value;
- (void)removePhotosObject:(NSManagedObject *)value;
- (void)addPhotos:(NSSet *)value;
- (void)removePhotos:(NSSet *)value;

@end

