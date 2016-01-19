//
//  ViewController_02.h
//  ExpansionTableTest
//
//  Created by besDigital on 16/1/19.
//  Copyright © 2016年 besniba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController_02 : UIViewController <UITableViewDelegate,
UITableViewDataSource>

{
    UITableView *devicelistTableView;
    NSMutableArray *grouplist;
    NSMutableArray *expandedGroups;
    NSMutableDictionary *groupSpeakerlistDict;
    
}



@end
