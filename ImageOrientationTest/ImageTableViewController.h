//
//  ImageTableViewController.h
//  ImageOrientationTest
//
//  Created by malczak on 16.05.2013.
//  Copyright (c) 2013 sfs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageTableViewDelegate;

@interface ImageTableViewController : UITableViewController <UITableViewDataSource>

@property (weak, nonatomic) id<ImageTableViewDelegate> delegate;

@end

@protocol ImageTableViewDelegate

-(void) imageTableView:(ImageTableViewController*) tableView didSelectImage:(UIImage*) image;

@end
