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
@property (nonatomic, copy) NSString *module;
@property (nonatomic, copy) NSString *function;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSString *clazzName;
@property (nonatomic, assign) BOOL isClazzMethod;
@property (nonatomic, strong) NSArray<DYCParam *> *params;

- (DYCProtocol *)function:(NSString *)function;

- (DYCProtocol *)selector:(SEL)selector;

- (DYCProtocol *)param:(DYCParam *)param;

@end

NS_ASSUME_NONNULL_END
