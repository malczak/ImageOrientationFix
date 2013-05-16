//
//  ImageTableViewController.m
//  ImageOrientationTest
//
//  Created by malczak on 16.05.2013.
//  Copyright (c) 2013 sfs. All rights reserved.
//

#import "ImageTableViewController.h"

@interface ImageTableViewController () {
    NSArray *images;
}

-(void) setupImagesArray;

@end

@implementation ImageTableViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIImage*) imageNamed:(NSString*)name
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *url = [bundle pathForResource:name ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:url];
}

-(void) setupImagesArray
{
    images = [NSArray arrayWithObjects:
              [self imageNamed:@"down-mirrored"],
              [self imageNamed:@"down"],
              [self imageNamed:@"left-mirrored"],
              [self imageNamed:@"left"],
              [self imageNamed:@"right-mirrored"],
              [self imageNamed:@"right"],
              [self imageNamed:@"up-mirrored"],
              [self imageNamed:@"up"],
              nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupImagesArray];
    
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    UIImage* image = [images objectAtIndex:index];
    if(nil!=delegate) {
        [delegate imageTableView:self didSelectImage:image];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [images count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellId = @"image-cell";

    UIImageView *imageView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(nil==cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 1;
        [cell.contentView addSubview:imageView];
    } else {
        imageView = (UIImageView*)[cell.contentView viewWithTag:1];
    }
    
    int rowIdx = [indexPath row];
    imageView.image = [images objectAtIndex:rowIdx];
    return cell;
}

@end
