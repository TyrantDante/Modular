//
//  Protocol.m
//  DYCModular
//
//  Created by 戴易超 on 2019/10/31.
//

#import "DYCProtocol.h"
@implementation DYCProtocol


- (DYCProtocol *(^)(NSString *))functioon {
    return ^DYCProtocol *(NSString *function) {
        NSParameterAssert(function);
        self.function = function;
        return self;
    };
}

- (DYCProtocol *)function:(NSString *)function {
    return self.functioon(function);
}

- (DYCProtocol *(^)(SEL))selectoor {
    return ^DYCProtocol *(SEL selector) {
        self.selector = selector;
        return self;
    };
}

- (DYCProtocol *)selector:(SEL)selector {
    return self.selectoor(selector);
}

- (DYCProtocol *(^)(DYCParam*))param {
    return ^DYCProtocol *(DYCParam* param) {
        return self;
    };
}

- (DYCProtocol *)param:(DYCParam *)param {
    return self.param(param);
}

@end
