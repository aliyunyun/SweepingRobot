//
//  ViewController.m
//  sweepingRobot
//
//  Created by mac on 15/6/9.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import "BDVRSConfig.h"

#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"

//#warning 请修改为您在百度开发者平台申请的API_KEY和SECRET_KEY
#define API_KEY @"HBhyFgGeBnzqXUcB5eIESYgG" // 请修改为您在百度开发者平台申请的API_KEY
#define SECRET_KEY @"6hV4aFaVESPI4QL8rSRyPaHzyC7xYy6I" // 请修改您在百度开发者平台申请的SECRET_KEY



@interface ViewController () <BDRecognizerViewDelegate >


@property (nonatomic, strong) BDRecognizerViewController *recognizerViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *BDRecognizerButton =[[UIButton alloc]initWithFrame:CGRectMake( 140, 270, 100, 40)];
    [BDRecognizerButton setTitle:@"语音识别" forState:UIControlStateNormal];
    [BDRecognizerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    BDRecognizerButton.layer.borderColor = [UIColor blackColor].CGColor;
    BDRecognizerButton.layer.borderWidth = 2;
    BDRecognizerButton.layer.cornerRadius = 5;
    BDRecognizerButton.layer.masksToBounds = YES;
    [BDRecognizerButton addTarget:self action:@selector(sdkUIRecognitionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BDRecognizerButton];

    
    UIButton *BDVoiceButton = [[UIButton alloc]initWithFrame:CGRectMake(140, 370, 100, 40)];
    [BDVoiceButton setTitle:@"长按说话" forState:UIControlStateNormal];
    [BDVoiceButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    BDVoiceButton.layer.borderColor = [UIColor blackColor].CGColor;
    BDVoiceButton.layer.borderWidth = 2;
    BDVoiceButton.layer.cornerRadius = 5;
    BDVoiceButton.layer.masksToBounds = YES;
    [BDVoiceButton addTarget:self action:@selector(sdkUIRecognitionAPIAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BDVoiceButton];

}


- (void)sdkUIRecognitionAPIAction:(UIButton *)button
{

}


- (void)sdkUIRecognitionAction:(UIButton*)button
{
   // [self clean];
    
    // 创建识别控件
    BDRecognizerViewController *tmpRecognizerViewController = [[BDRecognizerViewController alloc] initWithOrigin:CGPointMake(9, 128) withTheme:[BDVRSConfig sharedInstance].theme];
    
    // 全屏UI
    if ([[BDVRSConfig sharedInstance].theme.name isEqualToString:@"全屏亮蓝"]) {
        tmpRecognizerViewController.enableFullScreenMode = YES;
    }
    
    tmpRecognizerViewController.delegate = self;
    self.recognizerViewController = tmpRecognizerViewController;
    
    // 设置识别参数
    BDRecognizerViewParamsObject *paramsObject = [[BDRecognizerViewParamsObject alloc] init];
    
    // 开发者信息，必须修改API_KEY和SECRET_KEY为在百度开发者平台申请得到的值，否则示例不能工作
    paramsObject.apiKey = API_KEY;
    paramsObject.secretKey = SECRET_KEY;
    
    // 设置是否需要语义理解，只在搜索模式有效
    paramsObject.isNeedNLU = [BDVRSConfig sharedInstance].isNeedNLU;
    
    // 设置识别语言
    paramsObject.language = [BDVRSConfig sharedInstance].recognitionLanguage;
    
    // 设置识别模式，分为搜索和输入
    paramsObject.recogPropList = @[[BDVRSConfig sharedInstance].recognitionProperty];
    
    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
    paramsObject.cityID = 1;
    
    // 开启联系人识别
    //    paramsObject.enableContacts = YES;
    
    // 设置显示效果，是否开启连续上屏
    if ([BDVRSConfig sharedInstance].resultContinuousShow)
    {
        paramsObject.resultShowMode = BDRecognizerResultShowModeContinuousShow;
    }
    else
    {
        paramsObject.resultShowMode = BDRecognizerResultShowModeWholeShow;
    }
    
    // 设置提示音开关，是否打开，默认打开
    if ([BDVRSConfig sharedInstance].uiHintMusicSwitch)
    {
        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
    }
    else
    {
        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordForbidden;
    }
    
    paramsObject.isShowTipAfter3sSilence = NO;
    paramsObject.isShowHelpButtonWhenSilence = NO;
    paramsObject.tipsTitle = @"可以使用如下指令记账";
    paramsObject.tipsList = [NSArray arrayWithObjects:@"我要记账", @"买苹果花了十块钱", @"买牛奶五块钱", @"第四行滚动后可见", @"第五行是最后一行", nil];
    
    [_recognizerViewController startWithParams:paramsObject];
    
    
}

/**
 * @brief 语音识别结果返回，搜索和输入模式结果返回的结构不相同
 *
 * @param aBDRecognizerView 弹窗UI
 * @param aResults 返回结果，搜索结果为数组，输入结果也为数组，但元素为字典
 */
- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerViewController withResults:(NSArray *)aResults
{
    
    if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
    {
        // 搜索模式下的结果为数组，示例为
        // ["公园", "公元"]
        NSMutableArray *audioResultData = (NSMutableArray *)aResults;
        //    NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
        

            if ([audioResultData count] > 1) {
                //  NSString *printerString = @"打印";
                //  [self predicateCommandToPrinter:[audioResultData objectAtIndex:0]];
                [self predicateCommandToPrinter:audioResultData];
            }
        
    }
    else
    {
        // 输入模式下的结果为带置信度的结果，示例如下：
        //  [
        //      [
        //         {
        //             "百度" = "0.6055192947387695";
        //         },
        //         {
        //             "摆渡" = "0.3625582158565521";
        //         },
        //      ]
        //      [
        //         {
        //             "一下" = "0.7665404081344604";
        //         }
        //      ],
        //   ]
        NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aResults];
        
    }
    
}

- (void)predicateCommandToPrinter:(NSArray *)array
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS '打印'"];
    
    NSArray *newArray = [array filteredArrayUsingPredicate:predicate];
    NSLog(@" containe %ld ", newArray.count);
    
    if (newArray.count >= 1) {
    //    [self sendToBle:nil];
        NSLog(@" da yin l ");
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
