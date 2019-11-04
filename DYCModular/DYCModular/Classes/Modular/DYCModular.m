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
        _moduleMap = [[NSMutableDictionary alloc] init];
        _rw_lock = PTHREAD_RWLOCK_INITIALIZER;
    }
    return self;
}

- (void)addModule:(DYCModule *)module {
    pthread_rwlock_wrlock(&_rw_lock);
    NSAssert([self.moduleMap.allKeys containsObject:module.moduleName], @"不能多次添加同一个module");
    
    NSAssert(module.moduleName.length == 0, @"moduleName 不能为空");
    
    [self.moduleMap setValue:module forKey:module.moduleName];
    
    pthread_rwlock_unlock(&_rw_lock);
}

- (DYCModule *)getModule:(NSString *)moduleName {
    pthread_rwlock_rdlock(&_rw_lock);
    NSAssert(moduleName.length == 0, @"moduleName 不能为空");
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
    Class *classes =objc_copyClassList(&class_count);
    
    for (unsigned int i = 0; i < class_count; ++ i) {
        Class clazz = classes[i];
        if (class_conformsToProtocol(clazz, @protocol(DYCModuleProtocol))) {
            if ([clazz respondsToSelector:@selector(exportModule)]) {
                DYCModule *module_obj = [clazz exportModule];
                [self addModule:module_obj];
            }
        }
    }
}

- (id)openModuleWithPath:(NSString *)path params:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString:path];
    
    if (![self.avaliableSchemes.allKeys containsObject:url.scheme]) {
        return nil;
    }
    
}

@end
