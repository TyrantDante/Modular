//
//  DYCParam.h
//  DYCModular
//
//  Created by 戴易超 on 2019/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DYCParamTypeNone,
    DYCParamTypeString,
    DYCParamTypeNumber,
    DYCParamTypeMap,
    DYCParamTypeArray,
    DYCParamTypeObject,
    DYCParamTypeBlock,
} DYCParamType;

@interface DYCParam : NSObject
@property (nonatomic, strong) NSString *paramName;
@property (nonatomic, assign) DYCParamType paramType;
//初始化
+ (DYCParam *(^)(void))create;
+ (DYCParam *)creator;

//设置属性别名
- (DYCParam *(^)(NSString *))name;
- (DYCParam *)name:(NSString *)name;

//设置属性名称
- (DYCParam *(^)(DYCParamType))type;
- (DYCParam *)type:(DYCParamType)type;

- (id)formatValue:(id)value;
@end

NS_ASSUME_NONNULL_END
