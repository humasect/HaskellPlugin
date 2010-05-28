//
//  HYHaskellCommandOutputParser.m
//  HaskellPlugin
//
//  Created by Lyndon Tremblay on 25/12/06.
//  Copyright 2006 Lyndon Tremblay. All rights reserved.
//

#import "HYHaskellCommandOutputParser.h"
#import "XCPSupport.h"

@implementation HYHaskellCommandOutputParser

- initWithNextOutputStream:(XCOutputStream *)os
{
	if ((self = [super initWithNextOutputStream: os]))
	{
		lastFilePath = @"Tool";
		lastRow = 0;
		lastColumn = 0;
		lastMessageType = 1000;
		lastEoc = 0;
	}

	return self;
}

- (void)writeBytes:(const char *)data length:(unsigned int)length
{
	if (length <= 4)
	{
		NSLog(@"SMALL LENGTH");
		lastMessageType = 1000;
		[super writeBytes: data length: length];
		return;
	}

	NSString* line = [[[NSString alloc] initWithBytes:data length:length encoding:NSASCIIStringEncoding] autorelease];
	//NSLog(@"writeBytes %@ (%i type)", line, lastMessageType);

	int c = 0;
	int i;
	for (i=0 ; i<length ; i++)
		if (data[i] == ':')
			c++;

	if (c >= 2)
	{
//		NSRange r = [line rangeofCharacterFromSet:
//			[NSCharacterSet characterSetWithCharactersInString: "::"]
//			options: NSBackwardSearch];
		NSRange r = [line rangeOfString: @"::" options: NSBackwardsSearch];
		NSString *str;
		
		//if (NSEqualRanges(r, {NSNotFound, 0}) == NO)
		if (r.location != NSNotFound)
		{
			//str = [line substringWithRange: r];
			str = [line substringFromIndex: r.location + 2];
			//lastMessageType = 2;
		}
		else
		{
			str = line;
			//lastMessageType = 1;
		}

		NSArray *comp = [str componentsSeparatedByString: @":"];
		NSLog(@"Found possible = %@, %i", str, [comp count]);

		int index = 0;

//		if ([comp count] > 2) // no worries
//		{
////			lastColumn = [[comp objectAtIndex: 2] intValue];
//			lastRow = lastColumn = 0;
//			//lastMessageType = 1000;
//		}
//		else

		{
			int x = 0;
			NSString *fp = nil;

			if ([comp count] > index+1)
				x = [[comp objectAtIndex: index+1] intValue];
			if ([comp count] > index)
				fp = [comp objectAtIndex: index];

			if (x > 0)
			{
				lastRow = x;

				// fix it up
				NSArray *a = [fp componentsSeparatedByString: @" "];
				NSString *s = [a objectAtIndex: [a count] - 1];

				[lastFilePath release];
				lastFilePath = [s retain];

				if ([lastFilePath hasSuffix: @".hs"] || [lastFilePath hasSuffix: @".lhs"] || [lastFilePath hasSuffix: @".hsc"])
					lastMessageType = 1;
				else
					lastMessageType = 2;

				NSLog(@"AGREED. %@ --- %i", lastFilePath, lastRow);
			}
		}
	}

	if (lastMessageType < 1000)
	{
		[[self delegate]
			parser: self foundMessageOfType: lastMessageType
			//title: [[NSString stringWithFormat: @"%@:%i", lastFilePath, lastRow] cString]
			title: [line cString]
			forFileAtPath: [lastFilePath cString]
			lineNumber: lastRow];
		lastMessageType = 2;
	}

	[super writeBytes: data length: length];
}

- (void)dealloc
{
	[lastFilePath release];
	[super dealloc];
}

@end
