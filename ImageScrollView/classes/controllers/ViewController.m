//
//  ViewController.m
//  ImageScrollView
//
//  Created by Thiago Filadelfo on 26/01/13.
//  Copyright (c) 2013 Thiago. All rights reserved.
//

#import "ViewController.h"
#import "UIImageScrollView.h"

@interface ViewController ()
@property (nonatomic, weak)IBOutlet UIImageScrollView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *images = [NSArray arrayWithObjects:@"http://placedog.com/400/300", @"http://placedog.com/400/300", @"http://placedog.com/400/300", @"http://placedog.com/400/300", @"http://placedog.com/400/300", @"http://placedog.com/400/300", nil];
    self.imageView.images = images;
    //[self.imageView removeFromSuperview];
    
    //UIImageScrollView *isv = [[UIImageScrollView alloc] initWithFrame:CGRectMake(5, 5, 200, 200)];
    //isv.images = images;
    //[self.view addSubview:isv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
