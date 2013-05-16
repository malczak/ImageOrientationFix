//
//  ViewController.m
//  ImageOrientationTest
//
//  Created by malczak on 16.05.2013.
//  Copyright (c) 2013 sfs. All rights reserved.
//

#import "ViewController.h"
#import "ImageTableViewController.h"

void getOrinetationFixTransform(UIImage *image, CGAffineTransform *T)
{
    UIImageOrientation orientation = image.imageOrientation;
    
    CGAffineTransform fixT = CGAffineTransformIdentity;

    switch (orientation) {
        case UIImageOrientationUp: // EXIF 1
            break;
        case UIImageOrientationDown: // EXIF 3
            fixT = CGAffineTransformRotate(fixT, M_PI);
            break;
        case UIImageOrientationLeft: // EXIF 6
            fixT = CGAffineTransformRotate(fixT, M_PI/2.0);
            break;
        case UIImageOrientationRight: // EXIF 8
            fixT = CGAffineTransformRotate(fixT, 3.0*M_PI/2.0);
            break;
        case UIImageOrientationUpMirrored: // EXIF 2
            fixT = CGAffineTransformScale(fixT, -1, 1);
            break;
        case UIImageOrientationDownMirrored: // EXIF 4
            fixT = CGAffineTransformScale(fixT, 1, -1);
            break;
        case UIImageOrientationLeftMirrored: // EXIF 5
            fixT = CGAffineTransformScale(fixT, -1, 1);
            fixT = CGAffineTransformRotate(fixT, 3.0*M_PI/2.0);
            break;
        case UIImageOrientationRightMirrored: // EXIF 7
            fixT = CGAffineTransformScale(fixT, -1, 1);
            fixT = CGAffineTransformRotate(fixT, M_PI/2.0);
            break;
    }
    
    *T = fixT;
}

@interface ViewController (){
    UIPopoverController *popover;
}

@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fixedImageView;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.originalImageView.contentMode = UIViewContentModeCenter;
    self.fixedImageView.contentMode = UIViewContentModeCenter;
}

- (IBAction)showImageTable:(id)sender {
    UIButton *button = (UIButton*)sender;
    ImageTableViewController *viewController = [[ImageTableViewController alloc] init];
    viewController.delegate = self;

    popover = [[UIPopoverController alloc] initWithContentViewController:viewController];
    popover.delegate = self;
    [popover setPopoverContentSize:CGSizeMake(320, 240)];
    [popover presentPopoverFromRect:button.frame
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionUp
                           animated:NO];
}

-(void)imageTableView:(ImageTableViewController *)tableView didSelectImage:(UIImage *)image
{
    tableView.delegate = nil;
    popover.delegate = nil;
    [popover dismissPopoverAnimated:NO];
    
    self.originalImageView.image = image;
    [self fixImage:image];
}

-(void) fixImage:(UIImage*) image
{
    CGSize imageSize = image.size;
    
    CGImageRef cgImage = [image CGImage];
    CGFloat cgWidth = CGImageGetWidth(cgImage);
    CGFloat cgHeight = CGImageGetHeight(cgImage);
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, 0.3, 0, 0, 1.0);
    CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    
    CGAffineTransform T = CGAffineTransformIdentity;
    CGAffineTransform reorientT = CGAffineTransformMakeRotation(M_PI/12.0);
    
    getOrinetationFixTransform(image, &reorientT);
    
    T = CGAffineTransformConcat(T, CGAffineTransformMakeTranslation(-cgWidth*0.5, -cgHeight*0.5) );
    T = CGAffineTransformConcat(T, reorientT);
    T = CGAffineTransformConcat(T, CGAffineTransformMakeScale(1, -1));
    T = CGAffineTransformConcat(T, CGAffineTransformMakeTranslation(imageSize.width*0.5, imageSize.height*0.5));

    CGContextConcatCTM(ctx, T);
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, cgWidth, cgHeight), cgImage);
    
    UIImage *fixed = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.fixedImageView.image = fixed;
}



@end
