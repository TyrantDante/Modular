
//
//  Protocol.h
//  DYCModular
//
//  Created by 戴易超 on 2019/10/31.
//

#import <Foundation/Foundation.h>
#import "DYCParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface DYCProtocol : NSObject
@property (nonatomic, strong) NSString *module;
@property (nonatomic, readonly) NSString *protocolFunction;
@property (nonatomic, readonly) SEL protocolSelector;
@property (nonatomic, copy) NSString *clazzName;
@property (nonatomic, assign) BOOL isClazzMethod;
@property (nonatomic, readonly) NSArray<DYCParam *> *paramList;
//初始化
+ (DYCProtocol *(^)(void))create;
+ (DYCProtocol *)creator;

//协议名称
- (DYCProtocol *(^)(NSString *))function;
- (DYCProtocol *)function:(NSString *)function;

//协议实现方法
- (DYCProtocol *(^)(SEL))selector;
- (DYCProtocol *)selector:(SEL)selector;

//协议参数
- (DYCProtocol *(^)(DYCParam*))param;
- (DYCProtocol *)param:(DYCParam *)param;

@end

NS_ASSUME_NONNULL_END
