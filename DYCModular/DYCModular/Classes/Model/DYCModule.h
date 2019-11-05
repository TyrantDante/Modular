//
//  DYCModule.h
//  DYCModular
//
//  Created by 戴易超 on 2019/11/1.
//

#import <Foundation/Foundation.h>
#import "DYCProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface DYCModule : NSObject
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, strong) NSArray<DYCProtocol *>* protocols;
@property (nonatomic, copy) NSString *clazzName;
@end

NS_ASSUME_NONNULL_END
