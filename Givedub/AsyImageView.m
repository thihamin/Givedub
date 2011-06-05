//
//  AsyImageView.m
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyImageView.h"
#import "ASIHTTPRequest.h"

@implementation AsyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) loadImageFromUrl:(NSURL*)aUrl{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:aUrl];
    [request setDelegate:self];
    [request startAsynchronous];    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
//    NSString *responseString = [request responseString];
//    NSLog(@"%@", responseString);
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    
    UIImage *aImage = [UIImage imageWithData:responseData];
    
    self.image = aImage;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}


- (void)dealloc
{
    [super dealloc];
}

@end
