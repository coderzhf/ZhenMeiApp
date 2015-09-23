//
//  HomePageViewController.m
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/9.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeRecommendController.h"
#import "HomeHotPlayController.h"
#import "HomeGoodController.h"
#import "HomeActivityController.h"
#import "HomeSegmentView.h"
#import "HeaderSearchView.h"
#import "LocationInfoTool.h"
#import "HttpTool.h"
#import "HomePicture.h"
#import "HomeVideo.h"
#import "MJExtension.h"
#import "WMPageController.h"


@interface HomePageViewController ()<HomeSegementViewDelegate>
@property(nonatomic,weak)HomeSegmentView *segementView;
@property(nonatomic,weak)HeaderSearchView *searchView;
@property(nonatomic,assign)NSInteger Selectedtag;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)WMPageController *pageController;
@end

@implementation HomePageViewController
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.初始化导航栏
    [self setupNav];
    //2.初始化选择栏
   // [self setupSegemetView];
    //3.初始化子控制器
   // [self setupChildrenControllers];
    [self setupControllers];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark init 
//初始化导航栏
-(void)setupNav{

    CustomNavBar *customNav = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KnavHeight) isFirstPage:YES withTitle:nil];
    customNav.userInteractionEnabled = YES;
    [self.view addSubview:customNav];
    UIImageView *logoView = [[UIImageView alloc]init];
    logoView.image = [UIImage imageNamed:@"zm_logo_title"];
    logoView.width = 70;
    logoView.height = 23;
    logoView.left = 15;
    logoView.top = 20;
    [customNav addSubview:logoView];
    
    HeaderSearchView *search=[[HeaderSearchView alloc]init];
    search.frame=CGRectMake(KScreenWidth-180, KnavHeight-33, 180, 30);
    search.placeholderText=@"请输入搜索内容";
    [search.textField addTarget:self action:@selector(textFieldSearch:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [customNav addSubview:search];
}


- (void)setupControllers {
    self.pageController = [self getDefaultController];
    self.pageController.view.frame = CGRectMake(0, KnavHeight, KScreenWidth, KScreenHeight-KnavHeight);
    self.pageController.menuViewStyle = WMMenuViewStyleLine;
    self.pageController.titleSizeSelected = 15;
    self.pageController.titleColorSelected = ZhenMeiRGB(205, 173, 0);
    self.pageController.menuBGColor = [UIColor whiteColor];
    [self.view addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];
    
}

- (WMPageController *)getDefaultController{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        Class vcClass;
        NSString *title;
        switch (i) {
            case 0:
                vcClass = [HomeRecommendController class];
                title = @"推荐";
                break;
            case 1:
                vcClass = [HomeHotPlayController class];
                title = @"热播";
                break;
            case 2:
                vcClass = [HomeGoodController class];
                title = @"干货";
                break;
            case 3:
                vcClass = [HomeActivityController class];
                title = @"活动";
                break;
             default:
                break;
        }
        [viewControllers addObject:vcClass];
        [titles addObject:title];
    }
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.pageAnimatable = YES;
    pageVC.menuItemWidth = KScreenWidth/4;
    return pageVC;
}

//初始化选择栏
-(void)setupSegemetView{
    NSArray *titles=@[@"推荐",@"热播",@"干货",@"活动"];
    NSArray *types=@[@(HomeSegmentButtonReconmend),@(HomeSegmentButtonHotPlay),@(HomeSegmentButtonGood),@(HomeSegmentButtonActivity)];
    HomeSegmentView *SegementView=[HomeSegmentView initButtonWithTitleArray:titles type:types];
    SegementView.width=KScreenWidth;
    SegementView.height=30;
    SegementView.top=KnavHeight;
    [self.view addSubview:SegementView];
    SegementView.delegate=self;
    self.segementView=SegementView;

}

- (void)textFieldSearch:(UITextField *)field
{
    HomeActivityController *Controller=(HomeActivityController *)self.pageController.currentViewController;
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"articleId"]=field.text;
    NSLog(@"%@",self.pageController.currentViewController.class);
    if (self.pageController.currentViewController.class ==[HomeRecommendController class]||self.pageController.currentViewController.class ==[HomeHotPlayController class]) {
        dict[@"tag"]=@(7);

        [HttpTool post:KHomeSearch params:dict success:^(id json) {
            NSArray *success = json[@"list"];
            if (!success.count){
                [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
                return;
             }
            NSMutableArray *temp=[NSMutableArray array];
            for (NSDictionary *dict in success) {
                HomeVideo *result=[HomeVideo objectWithKeyValues:dict];
                result.ID=dict[@"id"];
                [temp addObject:result];
            }
            Controller.dataArray = temp;
           
        } failure:^(NSError *error) {
        }];
        
        return;

    }
    if (self.pageController.currentViewController.class ==[HomeGoodController class]) dict[@"tag"]=@(9);
    if (self.pageController.currentViewController.class ==[HomeActivityController class]) dict[@"tag"]=@(10);

    [HttpTool post:KHomeSearch params:dict success:^(id json) {
        NSArray *success = json[@"list"];
        if (!success.count)
        {
            [Notifier UQToast:self.view text:[json objectForKey:@"msg"] timeInterval:NyToastDuration];
            return;
        }
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary *dict in success) {
            HomePicture *result=[HomePicture objectWithKeyValues:dict];
            result.ID=dict[@"id"];
            [temp addObject:result];
        }
        Controller.dataArray = temp;
        
    } failure:^(NSError *error) {
    }];    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
