//
//  DYCViewController.m
//  DYCModular
//
//  Created by 804054226@qq.com on 10/31/2019.
//  Copyright (c) 2019 804054226@qq.com. All rights reserved.
//

#import "DYCViewController.h"
#import <DYCModular/DYCModular.h>
@interface DYCViewController ()<DYCModuleProtocol>

@end

@implementation DYCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)testFunction:(NSString *)param1 param2:(NSString *)param2 {
    NSLog(@"%@,%@",param1,param2);
    return [NSString stringWithFormat:@"%@,%@", param1, param2];
}

+ (DYCModule *)exportModule {
    return DYCModule
            .create()
            .name(@"test")
            .protocol(
                      DYCProtocol
                      .create()
                      .function(@"func")
                      .selector(@selector(testFunction:param2:))
                      .param(
                             DYCParam
                             .create()
                             .name(@"param1")
                             .type(DYCParamTypeString)
                             )
                      .param(
                              DYCParam
                              .create()
                              .name(@"param2")
                              .type(DYCParamTypeString)
                              )
                      );
}

@end
