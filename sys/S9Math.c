//
//  S9Math.c
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#import "S9Math.h"

#ifndef MAXFLOAT
#define MAXFLOAT	0x1.fffffep+127f
#endif

static double eval(const char * buffer, int offset, int * bounds);

static double node(const char * buffer, int offset, int * bounds)
{
	int pos = offset + 1; // start from the second char
	
	if (buffer[offset] == '(') {
		return eval(buffer, pos, bounds); // eval sub expression
	}
	if (buffer[offset] == '-') {
		return -node(buffer, pos, bounds); // format: '-(x)'
	}
	
	for (; pos < *bounds; ++pos) {
		if (buffer[pos] == '+' ||
			buffer[pos] == '-' ||
			buffer[pos] == '*' ||
			buffer[pos] == '/' ||
			buffer[pos] == ')') {
			*bounds = pos;
			break;
		}
	}
	return atof(buffer + offset);
}

static double eval(const char * buffer, int offset, int * bounds)
{
	int pos = *bounds;
	float left = node(buffer, offset, &pos), right; // get left node first
	
	// primary operations
	do {
		if (pos >= *bounds) {
			return left; // finished
		}
		if (buffer[pos] == ')') {
			*bounds = pos + 1;
			return left; // end sub expression
		}
		
		offset = pos + 1; // next node offset
		
		if (buffer[pos] == '*') {
			pos = *bounds;
			left *= node(buffer, offset, &pos);
			continue;
		}
		if (buffer[pos] == '/') {
			pos = *bounds;
			right = node(buffer, offset, &pos);
			left = (right == 0 ? MAXFLOAT : left / right);
			continue;
		}
		
		break;
	} while (1);
	
	// secondary operations
	if (buffer[pos] == '+') {
		return left + eval(buffer, offset, bounds);
	}
	if (buffer[pos] == '-') {
		return left + eval(buffer, pos, bounds); // x - y - z <=> x + (-y - z)
	}
	
	// error
	return MAXFLOAT;
}

double calculate(const char * str)
{
	size_t len = strlen(str);
	char * buffer = (char *)malloc(len + 1);
	int i, j;
	double result;
	
	// remove white spaces
	bzero(buffer, len + 1);
	for (i = 0, j = 0; i < len; ++i) {
		if (str[i] != ' ' && str[i] != '\t') {
			buffer[j] = str[i];
			++j;
		}
	}
	
	// eval
	result = eval(buffer, 0, &j);
	free(buffer);
	return result;
}
