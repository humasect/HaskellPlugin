/*
	HYHaskellProductType.h - Haskell
	Copyright 2006 Lyndon Tremblay.
	Distributed under the GPL licence.
*/

#import "XCPSpecifications.h"

@interface HYHaskellProductType : XCProductTypeSpecification
- (void)computeProductDependenciesInTargetBuildContext:(PBXTargetBuildContext*)context;
- (XCLinkerSpecification*)linkerSpecificationForObjectFilesInTargetBuildContext:(PBXTargetBuildContext*)context;
@end
