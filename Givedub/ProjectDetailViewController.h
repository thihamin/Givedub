//
//  ProjectDetailViewController.h
//  Givedub
//
//  Created by Thiha Min on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ProjectDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *mTableView;
    
    Project *project;
    
    NSMutableArray *detailsArray;
}

@property(nonatomic, retain) IBOutlet UITableView *mTableView;
@property(nonatomic, retain) Project *project;
@property(nonatomic, retain) NSMutableArray *detailsArray;

- (void) addProject:(Project*) aProject;
- (void) loadProject;
@end
