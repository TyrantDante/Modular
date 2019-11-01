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
    DYCParamTypeObject,
    DYCParamTypeBlock,
} DYCParamType;

@interface DYCParam : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) DYCParamType type;
@end

NS_ASSUME_NONNULL_END
