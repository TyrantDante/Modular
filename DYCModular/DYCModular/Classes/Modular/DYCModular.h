//
//  DYCModular.h
//  DYCModular
//
//  Created by 戴易超 on 2019/11/1.
//

#import <Foundation/Foundation.h>
#import "DYCModule.h"
NS_ASSUME_NONNULL_BEGIN

@protocol DYCModuleProtocol <NSObject>

+ (DYCModule *)exportModule;

@end
@interface DYCModularManager : NSObject
+ (DYCModularManager *)shareInstance;

- (void)addModule:(DYCModule *)module;

- (DYCModule *)getModule:(NSString *)moduleName;

- (void)addSchemes:(NSArray *)schemes;

- (void)removeSchemes:(NSArray *)schemes;

- (id)openModuleWithPath:(NSString *)path params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
