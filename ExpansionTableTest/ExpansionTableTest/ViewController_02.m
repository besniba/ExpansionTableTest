//
//  ViewController.m
//  ExpansionTableTest
//
//  Created by besDigital on 16/1/15.
//  Copyright © 2016年 besniba. All rights reserved.
//

#import "ViewController_02.h"

#import "SpeakerGroupFooterView.h"

@interface ViewController_02 ()

@end

@implementation ViewController_02

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setAutoresizesSubviews:YES];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self.view setClearsContextBeforeDrawing:YES];
    [self.view setOpaque:YES];
    [self.view setClipsToBounds:YES];
    
    [self besLoadData];
    [self besLoadDevicelistTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [devicelistTableView reloadData];
}

- (void)besLoadData
{
    grouplist = [NSMutableArray arrayWithObjects:@"group1",
                 //                 @"group2", @"group3", @"group4",
                 nil];
    
    groupSpeakerlistDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            [NSArray arrayWithObjects:@"speaker1", @"speaker2", nil], [grouplist objectAtIndex:0],
                            //                            [NSArray arrayWithObjects:@"speaker1", @"speaker2", @"speaker2", nil], [grouplist objectAtIndex:1],
                            //                            [NSArray arrayWithObjects:@"speaker1", @"speaker2", @"speaker2", @"speaker2", nil], [grouplist objectAtIndex:2],
                            //                            [NSArray arrayWithObjects:@"speaker1", nil], [grouplist objectAtIndex:3],
                            nil];
    
    expandedGroups = [[NSMutableArray alloc] init];
}

- (void)besLoadDevicelistTableView
{
    CGFloat frame_y = 50;
    CGFloat frame_w = CGRectGetWidth(self.view.frame)-10*2;
    
    devicelistTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, frame_y, frame_w, 600)
                                                       style:UITableViewStyleGrouped];
    
    if ([devicelistTableView respondsToSelector:@selector(setSeparatorStyle:)]) {
        
        [devicelistTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    [devicelistTableView setDelegate:self];
    [devicelistTableView setDataSource:self];
    [devicelistTableView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:devicelistTableView];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [grouplist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *group = [grouplist objectAtIndex:section];
    
    if ([expandedGroups containsObject:group]) {
        
        NSArray *speakerlist = [groupSpeakerlistDict objectForKey:group];
        
        return [speakerlist count]+1;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 60;
    }
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.01;
    }
    
    return 20;
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    NSLog(@"section:%ld", section);
    
    if (section%2 == 0) {
        
        return 30;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section%2 == 0) {
        
        static NSString *indentifier = @"GrouplistFooterView";
        
        SpeakerGroupFooterView *footer = [[SpeakerGroupFooterView alloc] initWithReuseIdentifier:indentifier];
        
        if (!footer) {
            
            footer = [[SpeakerGroupFooterView alloc] init];
        }
        
        [footer.showSpeakerlistBtn setTag:section+2000];
        [footer.showSpeakerlistBtn addTarget:self
                                      action:@selector(selectorOfShowDetailBtnPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
        
        
        return footer;
    }
    else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        
        [view setBackgroundColor:[UIColor whiteColor]];
        
        return view;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"USBDevicelistTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSLog(@"section:%ld \t row:%ld", indexPath.section, indexPath.row);
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.contentView setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    [cell.selectedBackgroundView setFrame:cell.bounds];
    
    NSString *item = nil;
    
    if (indexPath.row == 0) {
        
        item = [grouplist objectAtIndex:indexPath.section];
    }
    else {
        
        NSString *group = [grouplist objectAtIndex:indexPath.section];
        
        NSArray *speakerlist = [groupSpeakerlistDict objectForKey:group];
        
        item = [speakerlist objectAtIndex:indexPath.row-1];
    }
    
    [cell.textLabel setText:item];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (indexPath.row == 0) {
            
            NSString *selectedGroup = [grouplist objectAtIndex:indexPath.section];
            
            SpeakerGroupFooterView *footerView = (SpeakerGroupFooterView *)[tableView footerViewForSection:indexPath.section];
            UIButton *showSpeakerlistBtn = [footerView showSpeakerlistBtn];
            
            if ([expandedGroups containsObject:selectedGroup]) {
                
                [expandedGroups removeObject:selectedGroup];
                
                NSArray *speakerlist = [groupSpeakerlistDict objectForKey:selectedGroup];
                
                
                NSMutableArray *deleteArray = [NSMutableArray array];
                
                for (int i = 1; i < [speakerlist count]+1; i++) {
                    
                    [deleteArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                }
                
                [CATransaction begin];
                [tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
                [showSpeakerlistBtn.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
                [CATransaction commit];
                
            }
            else {
                
                [expandedGroups addObject:selectedGroup];
                
                NSArray *speakerlist = [groupSpeakerlistDict objectForKey:selectedGroup];
                
                NSMutableArray *insertArray = [NSMutableArray array];
                
                for (int i = 1; i < [speakerlist count]+1; i++) {
                    
                    [insertArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                }
                
                [CATransaction begin];
                [tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationAutomatic];
                [showSpeakerlistBtn.imageView setTransform:CGAffineTransformIdentity];
                [CATransaction commit];
            }
        }
    });
}

- (void)selectorOfShowDetailBtnPressed:(UIButton *)btn {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger section = btn.tag - 2000;
        
        NSString *selectedGroup = [grouplist objectAtIndex:section];
        
        SpeakerGroupFooterView *footerView = (SpeakerGroupFooterView *)[devicelistTableView footerViewForSection:section];
        UIButton *showSpeakerlistBtn = [footerView showSpeakerlistBtn];
        
        if ([expandedGroups containsObject:selectedGroup]) {
            
            [expandedGroups removeObject:selectedGroup];
            
            NSArray *speakerlist = [groupSpeakerlistDict objectForKey:selectedGroup];
            
            
            NSMutableArray *deleteArray = [NSMutableArray array];
            
            for (int i = 1; i < [speakerlist count]+1; i++) {
                
                [deleteArray addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            [CATransaction begin];
            [devicelistTableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
            [showSpeakerlistBtn.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
            [CATransaction commit];
            
        }
        else {
            
            [expandedGroups addObject:selectedGroup];
            
            NSArray *speakerlist = [groupSpeakerlistDict objectForKey:selectedGroup];
            
            NSMutableArray *insertArray = [NSMutableArray array];
            
            for (int i = 1; i < [speakerlist count]+1; i++) {
                
                [insertArray addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            [CATransaction begin];
            [devicelistTableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationAutomatic];
            [showSpeakerlistBtn.imageView setTransform:CGAffineTransformIdentity];
            [CATransaction commit];
        }
    });
    
}

@end
