//
//  Protocol.m
//  DYCModular
//
//  Created by 戴易超 on 2019/10/31.
//

#import "DYCProtocol.h"
@interface DYCProtocol()
@property (nonatomic, copy) NSString *protocolFunction;
@property (nonatomic, assign) SEL protocolSelector;
@property (nonatomic, strong) NSMutableArray<DYCParam *> *params;
@end


@implementation DYCProtocol


- (NSMutableArray<DYCParam *> *)params {
    if (_params == nil) {
        _params = [NSMutableArray array];
    }
    return _params;
}

- (NSArray<DYCParam *> *)paramList {
    return [self.params copy];
}

+ (DYCProtocol *(^)(void))create {
    return ^DYCProtocol *(void) {
        return [[DYCProtocol alloc] init];
    };
}

+ (DYCProtocol *)creator {
    return self.create();
}

- (DYCProtocol *(^)(NSString *))function {
    return ^DYCProtocol *(NSString *function) {
        NSParameterAssert(function);
        self.protocolFunction = function;
        return self;
    };
}

- (DYCProtocol *)function:(NSString *)function {
    return self.function(function);
}

- (DYCProtocol *(^)(SEL))selector {
    return ^DYCProtocol *(SEL selector) {
        self.protocolSelector = selector;
        return self;
    };
}

- (DYCProtocol *)selector:(SEL)selector {
    return self.selector(selector);
}

- (DYCProtocol *(^)(DYCParam*))param {
    return ^DYCProtocol *(DYCParam* param) {
        NSParameterAssert(param);
        [self.params addObject:param];
        return self;
    };
}

- (DYCProtocol *)param:(DYCParam *)param {
    return self.param(param);
}

@end
