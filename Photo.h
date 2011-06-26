//
//  Photo.h
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright 2011 Northeastern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Person;

@interface Photo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) Person * whoTook;

@end



