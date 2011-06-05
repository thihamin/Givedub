//
//  ProjectViewController.h
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProjectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *projects;
    IBOutlet UITableView *mTableView;
}

@property(nonatomic, retain) NSMutableArray *projects;
@property(nonatomic, retain) IBOutlet UITableView *mTableView;

- (IBAction)loadProjects:(id)sender;

@end
