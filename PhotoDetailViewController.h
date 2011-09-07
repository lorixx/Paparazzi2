//
//  PhotoDetailViewController.h
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright 2011 Northeastern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoDetailViewController : UIViewController {
	
	Photo *thisPhoto;
	UIImageView *imageView;


}

@property (nonatomic, retain) Photo *thisPhoto;
@property (nonatomic, retain) UIImageView *imageView;


- initWithPhoto: (Photo *)photo;


@end
