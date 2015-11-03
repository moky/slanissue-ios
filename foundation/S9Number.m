//
//  S9Number.m
//  SlanissueToolkit
//
//  Created by Moky on 15-11-3.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Number.h"

CFNumberRef CFNumberCreateWithInteger(int value)
{
	return CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &value);
}

CFNumberRef CFNumberCreateWithFloat(float value)
{
	return CFNumberCreate(kCFAllocatorDefault, kCFNumberFloatType, &value);
}

int CFNumberGetInteger(CFNumberRef numberRef)
{
	int value;
	CFNumberGetValue(numberRef, kCFNumberIntType, &value);
	return value;
}

float CFNumberGetFloat(CFNumberRef numberRef)
{
	float value;
	CFNumberGetValue(numberRef, kCFNumberFloatType, &value);
	return value;
}
