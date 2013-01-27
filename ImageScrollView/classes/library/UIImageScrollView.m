//
//  UIImageScrollView.m
//  ImageScrollView
//
//  Created by Thiago Filadelfo on 26/01/13.
//  Copyright (c) 2013 Thiago. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageScrollView.h"

@interface UIImageScrollView()

@property (nonatomic, retain) UIScrollView *view;
@property (nonatomic, retain) NSMutableArray *views;

@end

@implementation UIImageScrollView
@synthesize images=_images;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithFrame:self.bounds];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self internalInitWithFrame:self.bounds];
    }
    return self;
}


- (void)layoutSubviews
{
    CGSize pagesScrollViewSize = self.bounds.size;
    self.view.contentSize = CGSizeMake(pagesScrollViewSize.width * self.images.count, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    [self loadVisibleImage:0];

}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    int count = images.count;    
    self.views = [[NSMutableArray alloc] initWithCapacity:count];

    UIImage *placeholder = [UIImage imageNamed:@"icon_camera"];
    
    for (int i=0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:placeholder];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.tag = -1;
        
        CGRect frame = self.bounds;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = frame.origin.y - imageView.bounds.size.height;
        imageView.frame = frame;
        
        [imageView sizeToFit];
        
        [self.views addObject:imageView];
        [self.view addSubview:imageView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.bounds.size.width;
    int currentPage = (NSInteger)floor((self.view.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    [self loadVisibleImage:currentPage];
}

///////////////////////////////////////////////////////////////
//////// Internal constructor
///////////////////////////////////////////////////////////////
- (void)internalInitWithFrame:(CGRect)frame
{

    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    self.view = [[UIScrollView alloc] initWithFrame:rect];
    self.view.pagingEnabled = YES;
    self.view.delegate = self;
    self.view.contentSize = frame.size;
    self.view.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self addSubview:self.view];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    /*
    
    CALayer *layer = self.view.layer;
    layer.borderColor = [UIColor grayColor].CGColor;
    layer.borderWidth = 1;
    */
}


///////////////////////////////////////////////////////////////
//////// Loading images
///////////////////////////////////////////////////////////////
- (void)loadVisibleImage:(int)currentPage
{
    int page = currentPage;

    int firstPage = page;
    int lastPage = page + 1;
    
    //Pagina impares
    if(page % 2 != 0) {
        firstPage++;
        lastPage++;
    }
 
    if (firstPage >= 0 && firstPage < self.images.count) {
        [self loadImage:firstPage];
    }
        
    if (lastPage > 0 && lastPage < self.images.count) {
        [self loadImage:lastPage];
    }
}

- (void)loadImage:(int)page {
    
    UIImageView *imageView = [self.views objectAtIndex:page];
    
    if(imageView.tag == -1) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.images objectAtIndex:page]]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (data) {
                    CGRect frame = self.bounds;
                    
                    UIImage *image = [UIImage imageWithData:data];
                    
                    UIGraphicsBeginImageContext(frame.size);
                    [image drawInRect:CGRectMake(0,0,frame.size.width,frame.size.height)];
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    imageView.image = image;
                    imageView.contentMode = UIViewContentModeScaleToFill;
                    imageView.tag = page;
                    
                    
                    frame.origin.x = frame.size.width * page;
                    frame.origin.y = 0.0f;
                    imageView.frame = frame;
                    
                    [imageView sizeToFit];
                    
                    [self.views replaceObjectAtIndex:page withObject:imageView];
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
        }];
    }
}

@end
