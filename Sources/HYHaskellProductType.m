/*
	HYHaskellProductType.m - HaskellPlugin
	Copyright 2006-2007 Lyndon Tremblay.
	Distributed under the GPL licence.
*/

#import "HYHaskellProductType.h"
#import "XCPBuildSystem.h"

@implementation HYHaskellProductType
- (void) computeProductDependenciesInTargetBuildContext:(PBXTargetBuildContext*)context
{
	NSString* productPath = [context expandedValueForString:@"$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)"];
	//NSString* newProductPath = [INOCamlTools convertPath:productPath toByteCode:[context didUseOCamlByteCode]];
	//if(newProductPath != nil) productPath = newProductPath;

//	NSLog(@"asdasda1");
	XCDependencyNode* productNode = [context dependencyNodeForName:productPath createIfNeeded:YES];
	[context addProductNode:productNode];
//	NSLog(@"asdasda2");
}

- (XCLinkerSpecification*) linkerSpecificationForObjectFilesInTargetBuildContext:(PBXTargetBuildContext*)context
{
	XCSpecification* spec = [XCLinkerSpecification specificationForIdentifier:@"org.glasgow.haskell.linker"];
	return [[spec class] isSubclassOfClass:[XCLinkerSpecification class]] ? (XCLinkerSpecification*)spec : nil;
}
@end
