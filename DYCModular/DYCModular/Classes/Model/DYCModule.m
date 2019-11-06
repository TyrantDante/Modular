//
//  DYCModule.m
//  DYCModular
//
//  Created by 戴易超 on 2019/11/1.
//

#import "DYCModule.h"
@interface DYCModule()
@property (nonatomic, strong) NSMutableArray<DYCProtocol *>* protocols;

@end
@implementation DYCModule
- (NSMutableArray<DYCProtocol *> *)protocols {
    if (!_protocols) {
        _protocols = [[NSMutableArray alloc] init];
    }
    return _protocols;
}

- (NSArray<DYCProtocol *> *)protocolList {
    return [self.protocolList copy];
}

+ (DYCModule *(^)(void))create {
    return ^DYCModule* (void){
        return [[DYCModule alloc] init];
    };
}

+ (DYCModule *)creator {
    return self.create();
}

- (DYCModule * (^)(NSString *))name {
    return ^DYCModule *(NSString *name) {
        NSParameterAssert(name);
        self.moduleName = name;
        return self;
    };
}
- (DYCModule *)name:(NSString *)name {
    return self.name(name);
}

- (DYCModule * (^)(DYCProtocol *))protocol {
    return ^DYCModule *(DYCProtocol *protocol) {
        NSParameterAssert(protocol);
        protocol.module = self.moduleName;
        [self.protocols addObject:protocol];
        return self;
    };
}
- (DYCModule *)protocol:(DYCProtocol *)protocol {
    return self.protocol(protocol);
}
@end
