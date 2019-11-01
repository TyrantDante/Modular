//
//  DYCModular.h
//  DYCModular
//
//  Created by 戴易超 on 2019/11/1.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class DYCModule;
@protocol DYCModuleProtocol <NSObject>

+ (DYCModule *)exportModule;

@end
@interface DYCModularManager : NSObject
+ (DYCModularManager *)shareInstance;

- (void)addModule:(DYCModule *)module;

- (DYCModule *)getModule:(NSString *)moduleName;
@end

NS_ASSUME_NONNULL_END
