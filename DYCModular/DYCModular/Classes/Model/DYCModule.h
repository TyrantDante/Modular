//
//  DYCModule.h
//  DYCModular
//
//  Created by 戴易超 on 2019/11/1.
//

#import <Foundation/Foundation.h>
#import "DYCProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface DYCModule : NSObject
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, readonly) NSArray<DYCProtocol *>* protocolList;
@property (nonatomic, copy) NSString *clazzName;
//初始化
+ (DYCModule *(^)(void))create;
+ (DYCModule *)creator;

//设置模块名称
- (DYCModule * (^)(NSString *))name;
- (DYCModule *)name:(NSString *)name;


//设置模块协议,调用一次添加一个协议
- (DYCModule * (^)(DYCProtocol *))protocol;
- (DYCModule *)protocol:(DYCProtocol *)protocol;
@end

NS_ASSUME_NONNULL_END
