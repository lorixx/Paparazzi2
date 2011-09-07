//
//  PhotoDetailViewController.m
//  Paparazzi2
//
//  Created by Zhisheng Huang on 6/25/11.
//  Copyright 2011 Northeastern University. All rights reserved.
//

#import "PhotoDetailViewController.h"


@implementation PhotoDetailViewController

@synthesize thisPhoto;
@synthesize imageView;

- initWithPhoto: (Photo *)photo{
	
	
	thisPhoto = photo;
	self.navigationItem.title =[ thisPhoto valueForKey:@"imageName"];
	NSLog(@"%@", [ thisPhoto valueForKey:@"imageName"]);
	
	return self;
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *image = [UIImage imageNamed:[self.thisPhoto valueForKey:@"imageURL"]];
	self.imageView = [[UIImageView alloc] initWithImage:image];
	
	[self.view addSubview:self.imageView];
	[(UIScrollView*)self.view setContentSize:[image size]];
	[(UIScrollView*)self.view setMaximumZoomScale:2.0];

	
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[imageView release];
	[thisPhoto release];
    [super dealloc];
}


@end
