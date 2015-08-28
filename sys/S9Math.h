//
//  S9Math.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#ifndef __s9_math__
#define __s9_math__

//
//  Degree & Radian
//
#ifndef M_PI_180
#define M_PI_180    0.017453292519943295                    /* pi/180         */
#endif

#ifndef M_180_PI
#define M_180_PI    57.29577951308232                       /* 180/pi         */
#endif

#define DegreeToRadian(degree)    ((degree) * M_PI_180)
#define RadianToDegree(radian)    ((degree) * M_180_PI)


//
//  The Four Arithmetic Operations
//
// "200 * 73 / (543 - 178) - (2 + 2) / 2 * (((4 - 1) * 2 + (3 - 1)) + 1)" => 22
double calculate(const char * str);

//
//  MOD(x, y)
//
//  3 % 10 => 3
// -3 % 10 => 7
#define circulate(index, count) (                                              \
          ((count) <= 0) ?                                                     \
          (index) :                                                            \
          ({for (; (index) < 0; (index) += (count) << 8); (index) % (count);}) \
        )                                                                      \
                                                           /* EOF 'circulate' */

#endif /* defined(__s9_math__) */
