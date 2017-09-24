//
//  HomeViewController.m
//  Utopia
//
//  Created by jianjianhong on 17/9/21.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import "HomeViewController.h"
#import "TodayDetailViewController.h"
#import "WeekPlanViewController.h"
#import "HabitViewController.h"

@interface HomeViewController () <UIScrollViewDelegate>
    /* tab */
    @property(nonatomic, strong) UIView *tabBar;
    
    /* tab指示器 */
    @property(nonatomic, strong) UIView *tabIndicatorView;
    
    /* tab子项数组 */
    @property(nonatomic, strong) NSMutableArray *childTabItems;
    
    /* 当前选择的tab */
    @property(nonatomic, weak) UIButton *currentTab;
    
    /* scrollView */
    @property(nonatomic, weak) UIScrollView *contentView;
    
    /* tab 子控制器数组 */
    @property(nonatomic, strong) NSArray *childVCs;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavBar];
    [self initTabBar];
    [self initContentView];
}
    
    /**
     *  初始化顶部tab栏
     */
- (void)initTabBar {
    
    //创建tab
    UIView *tabBar = [[UIView alloc] init];
    tabBar.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 35);
    tabBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
    
    //设置tab items
    _childTabItems = [[NSMutableArray alloc] init];
    NSArray *tabData = @[@"今日安排", @"一周计划", @"我的习惯"];
    NSInteger tabLabelX = 0;
    NSInteger tabLabelY = 0;
    NSInteger tabLabelWidth = tabBar.frame.size.width / tabData.count;
    NSInteger tabLableHeight = tabBar.frame.size.height;
    for(NSInteger i = 0; i < tabData.count; i++) {
        UIButton *tabLabel = [[UIButton alloc] init];
        tabLabel.frame = CGRectMake(tabLabelX, tabLabelY, tabLabelWidth, tabLableHeight);
        [tabLabel setTitle:tabData[i] forState:UIControlStateNormal];
        [tabLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [tabLabel setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        tabLabel.titleLabel.font = [UIFont systemFontOfSize:14.0];
        tabLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        tabLabel.tag = i;
        [_childTabItems addObject:tabLabel];
        
        [tabLabel addTarget:self action:@selector(tablabelSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [tabBar addSubview:tabLabel];
        tabLabelX += tabLabelWidth;
    }
    
    
    //初始化指示器
    NSArray *views = [tabBar subviews];
    UIButton *button = views[0];
    [button.titleLabel sizeToFit];
    
    _tabIndicatorView = [[UIView alloc] init];
    _tabIndicatorView.frame = CGRectMake(0, 33, button.titleLabel.frame.size.width, 2);
    _tabIndicatorView.backgroundColor = [UIColor redColor];
    CGPoint center = _tabIndicatorView.center;
    center.x = button.center.x;
    _tabIndicatorView.center = center;
    [tabBar addSubview:_tabIndicatorView];
}
    
    /**
     *  点击tab item，item选择，并且contentView切换到相应的版面
     *
     *  @param button 选择的item
     */
- (void)tablabelSelect:(UIButton *)button {
    //设置item选择效果
    [self tabItemDidSelected:button];
    
    //让contentView显示item对应的版面
    CGPoint point = _contentView.contentOffset;
    point.x = button.tag * _contentView.frame.size.width;
    [_contentView setContentOffset:point animated:YES];
}
    
    /**
     *  设置tab item选中效果
     *
     *  @param button 选中的item
     */
- (void)tabItemDidSelected:(UIButton *)button {
    _currentTab.selected = NO;
    button.selected = YES;
    _currentTab = button;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _tabIndicatorView.frame;
        frame.size.width = button.titleLabel.frame.size.width;
        _tabIndicatorView.frame = frame;
        
        CGPoint center = _tabIndicatorView.center;
        center.x = button.center.x;
        _tabIndicatorView.center = center;
    }];
}
    
    /**
     *  初始化导航栏
     */
- (void)initNavBar {
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
}
    
    /**
     *  初始化内容滚动区
     */
- (void)initContentView {
    //取消自动insets
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建scrollerView
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = [self.view bounds];
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    [self.view insertSubview:contentView atIndex:0];
    _contentView = contentView;
    
    //创建子控制器
    TodayDetailViewController *todayDetailVC = [[TodayDetailViewController alloc] init];
    WeekPlanViewController *weekPlanVC = [[WeekPlanViewController alloc] init];
    HabitViewController *habitVC = [[HabitViewController alloc] init];
    
    //添加子控制器
    [self addChildViewController:todayDetailVC];
    [self addChildViewController:weekPlanVC];
    [self addChildViewController:habitVC];
    
    _childVCs = @[todayDetailVC, weekPlanVC, habitVC];
    
    //显示第一个控制器
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width * _childVCs.count, 0);
    todayDetailVC.view.frame = CGRectMake(contentView.contentOffset.x, 0, contentView.frame.size.width, contentView.frame.size.height);
//    CGFloat bottom = self.tabBarController.tabBar.frame.size.height;
//    CGFloat top = CGRectGetMaxY(self.tabBar.frame);
//    todayDetailVC.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    [_contentView addSubview:todayDetailVC.view];
}
    
    
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    [self scrollPage:scrollView];
}
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIButton *button = _childTabItems[index];
    [self tabItemDidSelected:button];
    
    [self scrollPage:scrollView];
}
    
- (void)scrollPage:(UIScrollView *)scrollView {
    //获取下标
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    UITableViewController *vc = _childVCs[index];
    
    vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.frame.size.height;
    CGFloat top = CGRectGetMaxY(self.tabBar.frame);
    vc.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    [scrollView addSubview:vc.view];
}

@end
