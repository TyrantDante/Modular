//
//  DYCModular.m
//  DYCModular
//
//  Created by 戴易超 on 2019/11/1.
//

#import "DYCModular.h"
#import <objc/runtime.h>
#import <pthread.h>
#import "DYCModule.h"
#import "DYCURL.h"
#import "DYCProtocol.h"

DYCModularManager *instance = nil;

@interface DYCModularManager()
@property (nonatomic, strong) NSMutableDictionary *moduleMap;
@property (nonatomic, assign) pthread_rwlock_t rw_lock;
@property (nonatomic, strong) NSMutableDictionary *avaliableSchemes;
@end

@implementation DYCModularManager
+ (DYCModularManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DYCModularManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        pthread_rwlockattr_t arr;
        pthread_rwlock_init(&_rw_lock, pthread_rwlockattr_init(&arr));
        [self staticSearchProtocol];
    }
    return self;
}

- (NSMutableDictionary *)moduleMap {
    if (!_moduleMap) {
        _moduleMap = [[NSMutableDictionary alloc] init];
    }
    return _moduleMap;
}

- (NSMutableDictionary *)avaliableSchemes {
    if (!_avaliableSchemes) {
        _avaliableSchemes = [[NSMutableDictionary alloc] init];
    }
    return _avaliableSchemes;
}

- (void)addModule:(DYCModule *)module {
    pthread_rwlock_wrlock(&_rw_lock);
    NSAssert(![self.moduleMap.allKeys containsObject:module.moduleName], @"不能多次添加同一个module");
    
    NSAssert(module.moduleName.length != 0, @"moduleName 不能为空");
    
    [self.moduleMap setValue:module forKey:module.moduleName];
    
    pthread_rwlock_unlock(&_rw_lock);
}

- (DYCModule *)getModule:(NSString *)moduleName {
    pthread_rwlock_rdlock(&_rw_lock);
    NSAssert(moduleName.length != 0, @"moduleName 不能为空");
    DYCModule *module = self.moduleMap[moduleName];
    pthread_rwlock_unlock(&_rw_lock);
    return module;
}

- (void)addSchemes:(NSArray *)schemes {
    for (NSString *scheme in schemes) {
        [self.avaliableSchemes setValue:@"1" forKey:scheme];
    }
}

- (void)removeSchemes:(NSArray *)schemes {
    for (NSString *scheme in schemes) {
        [self.avaliableSchemes removeObjectForKey:scheme];
    }
}

- (void)staticSearchProtocol {
    unsigned int class_count;
    Class *classes = objc_copyClassList(&class_count);
    
    for (unsigned int i = 0; i < class_count; ++ i) {
        Class clazz = classes[i];
        if (class_conformsToProtocol(clazz, @protocol(DYCModuleProtocol))) {
            if ([clazz respondsToSelector:@selector(exportModule)]) {
                DYCModule *module_obj = [clazz exportModule];
                if (module_obj.clazzName.length == 0) {
                    module_obj.clazzName = NSStringFromClass(clazz);
                }
                [self addModule:module_obj];
            }
        }
    }
    free(classes);
}

- (id)openModuleWithPath:(NSString *)path params:(NSDictionary *)params {
    DYCURL *url = [[DYCURL alloc] initWithString:path];
    if (![self.avaliableSchemes.allKeys containsObject:url.scheme]) {
        return nil;
    }
    NSArray<NSString *> *module_names = url.module_names;
    NSString *module_method = url.module_method;
    NSDictionary *module_param = params;
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *module_name in module_names) {
        DYCModule *module = [self getModule:module_name];
        if (module) {
            for (DYCProtocol *protocoo in module.protocolList) {
                if ([protocoo.protocolFunction isEqualToString:module_method]) {
                    if (protocoo.clazzName.length == 0) {
                        protocoo.clazzName = module.clazzName;
                    }
                    id rr = [self openModuleWithProtocol:protocoo param:module_param];
                    if (rr) {
                        [result addObject:rr];
                    }
                }
            }
        }
    }

    return result;
}

- (id)openModuleWithUrlString:(NSString *)urlString {
    DYCURL *url = [[DYCURL alloc] initWithString:urlString];
    if (![self.avaliableSchemes.allKeys containsObject:url.scheme]) {
        return nil;
    }
    NSArray<NSString *> *module_names = url.module_names;
    NSString *module_method = url.module_method;
    NSDictionary *module_param = url.module_param;
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *module_name in module_names) {
        DYCModule *module = [self getModule:module_name];
        if (module) {
            for (DYCProtocol *protocoo in module.protocolList) {
                if ([protocoo.protocolFunction isEqualToString:module_method]) {
                    if (protocoo.clazzName.length == 0) {
                        protocoo.clazzName = module.clazzName;
                    }
                    id rr = [self openModuleWithProtocol:protocoo param:module_param];
                    if (rr) {
                        [result addObject:rr];
                    }
                }
            }
        }
    }
    
    return result;
}


- (id)openModuleWithProtocol:(DYCProtocol *)protocol param:(NSDictionary *)param {
    Class clazz = NSClassFromString(protocol.clazzName);
    SEL selector = protocol.protocolSelector;
    NSMethodSignature *sig;

    if ([clazz respondsToSelector:selector]) {
        protocol.isClazzMethod = YES;
        sig = [clazz methodSignatureForSelector:selector];
    } else if ([[[clazz alloc] init] respondsToSelector:selector]) {
        protocol.isClazzMethod = NO;
        sig = [[[clazz alloc] init] methodSignatureForSelector:selector];
    } else {
        return nil;
    }
    NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:sig];
    invoke.selector = selector;
    if (protocol.isClazzMethod) {
        invoke.target = clazz;
    } else {
        id module = [[clazz alloc] init];
        invoke.target = module;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    NSArray<DYCParam *> *params = protocol.paramList;
    NSUInteger index = 1;
    for (DYCParam *param_ in params) {
        NSString *paramName = param_.paramName;
        index = index + 1;
        if (paramName.length == 0) {
            continue;
        }
        id paramValue = param[paramName];
        id formatValue = [param_ formatValue:paramValue];
        if (!formatValue) {
            continue;
        }
        [invoke setArgument:&formatValue atIndex:index];
    }
#pragma clang diagnostic pop

    [invoke retainArguments];
    [invoke invoke];

    NSUInteger length = sig.methodReturnLength;
    NSString *type = [NSString stringWithUTF8String:sig.methodReturnType];
    if (length == 0) {
        return nil;
    }
    if (![type isEqualToString:@"@"]) {
        return nil;
    }
    void *buffer;
    [invoke getReturnValue:&buffer];
    return (__bridge id)(buffer);
}




@end
