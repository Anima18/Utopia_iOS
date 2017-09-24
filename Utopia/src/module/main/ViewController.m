//
//  ViewController.m
//  Utopia
//
//  Created by jianjianhong on 17/9/21.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "PlanViewController.h"
#import "IdeaViewController.h"
#import "MeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setChildVC];
}


- (void)setChildVC{
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    homeVC.title = @"首页";
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"icon_home"];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    PlanViewController *planVC = [[PlanViewController alloc]init];
    planVC.title = @"计划实验室";
    planVC.tabBarItem.title = @"计划";
    planVC.tabBarItem.image = [UIImage imageNamed:@"icon_map"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:planVC];
    
    IdeaViewController *ideaVC = [[IdeaViewController alloc]init];
    ideaVC.title = @"构想孵化";
    ideaVC.tabBarItem.title = @"构想";
    ideaVC.tabBarItem.image = [UIImage imageNamed:@"icon_idea"];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:ideaVC];
    
    MeViewController *meVC = [[MeViewController alloc]init];
    meVC.title = @"我";
    meVC.tabBarItem.title = @"我";
    meVC.tabBarItem.image = [UIImage imageNamed:@"icon_user"];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:meVC];
    
    self.viewControllers = @[nav1,nav2,nav3,nav4];
}

- (UIImage *)imageFromColor:(UIColor *)color andFrame:(CGRect)frame{
    
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
