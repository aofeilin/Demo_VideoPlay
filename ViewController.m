//
//  ViewController.m
//  Demo_VideoPlay
//
//  Created by ule_zhangfanglin on 2017/1/23.
//  Copyright © 2017年 admin. All rights reserved.
//
#import "ViewController.h"
//设备屏幕大小
#define __MainScreenFrame   [[UIScreen mainScreen] bounds]
//设备屏幕宽
#define __MainScreen_Width  __MainScreenFrame.size.width
UIView * play_view;
UIButton * playButton;
BOOL hidden;
#define __MainScreen_Height __MainScreenFrame.size.height
@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    UITableView * m_tableView=[[UITableView alloc] initWithFrame:CGRectMake(20, 20, __MainScreen_Width-40, __MainScreen_Height)];
    m_tableView.delegate=self;
    m_tableView.dataSource=self;
    [self.view addSubview:m_tableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    play_view=[[UIView alloc] initWithFrame:CGRectMake(30,25 , __MainScreen_Width-40, 140)];
    [play_view setBackgroundColor:[UIColor redColor]];
    playButton =[[UIButton alloc] initWithFrame:CGRectMake(40,40 ,50 ,50 )];
    [playButton setTitle:@"放大" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setBackgroundColor:[UIColor brownColor]];
    [play_view addSubview:playButton];
    [playButton setUserInteractionEnabled:YES];
     [self.view addSubview:play_view];
    hidden=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

}


-(void)buttonAction:(id)sender
{
    
    if ([playButton.titleLabel.text isEqualToString:@"放大"]) {
        NSNumber *orientationLeft = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:orientationLeft forKey:@"orientation"];
          [playButton setTitle:@"缩小" forState:UIControlStateNormal];
          hidden=YES;
    }
    else
    {
        NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
          [playButton setTitle:@"放大" forState:UIControlStateNormal];
         hidden=NO;
    }
   [self setNeedsStatusBarAppearanceUpdate];
    
    
    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight];  ios9.0
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * tableViewCell= [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    UIView * view;
    if (!tableViewCell) {
         tableViewCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
         [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
         view =[[UIView alloc] initWithFrame:CGRectMake(10, 5,__MainScreen_Width-60 , 140)];
         [view setBackgroundColor:[UIColor grayColor]];
         [tableViewCell addSubview:view];
    }
    return tableViewCell;
}

-(BOOL)prefersStatusBarHidden
{
    if (hidden) {
          return YES;
    }
    else
    {
        return  NO;
    }
  
}
-(BOOL)shouldAutorotate
{
    return NO;
}
//横屏方法
- (void)orientChangeWithVideoSuperView:(UIView *)superView playerView:(UIView *)view playerViewRect:(CGRect)rect{
    
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    play_view.backgroundColor = [UIColor redColor];
    superView.layer.transform = CATransform3DIdentity;
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            superView.frame = [UIScreen mainScreen].bounds;
            view.frame = rect;
              [playButton setTitle:@"放大" forState:UIControlStateNormal];
            break;
      case UIDeviceOrientationLandscapeLeft:
      case UIDeviceOrientationLandscapeRight:
            superView.frame = CGRectMake(-CGRectGetHeight([UIScreen mainScreen].bounds)+CGRectGetWidth([UIScreen mainScreen].bounds), 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
            view.frame = CGRectMake(0, 0,CGRectGetHeight([UIScreen mainScreen].bounds),CGRectGetWidth([UIScreen mainScreen].bounds));
            superView.transform = CGAffineTransformMakeRotation(M_PI_2);
              [playButton setTitle:@"缩小" forState:UIControlStateNormal];
            break;
       default:
            break;
    }
}
//通知设备旋转了
- (void)orientChange:(NSNotification *)noti
{
    
    [self orientChangeWithVideoSuperView:self.view playerView:play_view playerViewRect:CGRectMake(30,25 , __MainScreen_Width-40, 140)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
