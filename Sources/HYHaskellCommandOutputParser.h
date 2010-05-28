//
//  HYHaskellCommandOutputParser.h
//  HaskellPlugin
//
//  Created by Lyndon Tremblay on 25/12/06.
//  Copyright 2006 Lyndon Tremblay <humasect@gmail.com>. All rights reserved.
//

#import "XCPOutputParsing.h"


@interface HYHaskellCommandOutputParser : XCBuildCommandOutputParser {
	NSString* lastFilePath;
	unsigned lastRow, lastColumn, lastEoc;
	unsigned lastMessageType;
}

- initWithNextOutputStream:(XCOutputStream*)os;
- (void)writeBytes:(const char *)data length:(unsigned int)length;

@end
