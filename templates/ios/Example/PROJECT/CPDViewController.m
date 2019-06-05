//
//  CPDViewController.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDViewController.h"
#import <SAKit/SAKit.h>
#import <SAModuleService/SAModuleService.h>


@interface CPDViewController ()<UITableViewDelegate,UITableViewDataSource,SAViewControllerSceneProtocol>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *componentArray;

@end

@implementation CPDViewController

- (SANavigationBarStyle)navigationBarStyle {
    return SANavigationBarStyleWhite;
}

- (BOOL)extendedToTop {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订购商品";
    
    
    self.componentArray = [NSArray arrayWithObjects:@"订购商品", @"采购车", @"注销", nil];
    
    [self.view addSubview:self.tableView];
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.componentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SAViewControler.cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.componentArray[indexPath.row];
    cell.textLabel.textColor = [UIColor sa_colorC1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
//            UIViewController<CMOrderProductProtocol> *viewController = [SAServiceManager createServiceWithProtocol:@protocol(CMOrderProductProtocol)];
//            viewController.sa_buId = @"10001719";
//            [self.navigationController pushViewController:viewController animated:YES];
        }
            
            break;
        case 1:
        {
            
        }
            
            break;
        default:
            //注销
            [[NSNotificationCenter defaultCenter] postNotificationName:SALoginModuleNeedLogoutNotification object:nil];
            break;
    }
}


@end
