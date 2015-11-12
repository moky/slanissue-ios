# SlanissueToolkit
**SlanissueToolkit.framework for iOS application**, copyright &copy;2015 [Slanissue.com][slanissue.com].

![Slanissue][slanissue.jpg]


## 1. Patches

### 1.1. Foundation

1. JSON en/decoding
2. MD5 encryption
3. Base64 en/decoding
4. URL escape, unescape
5. ...

### 1.2. CoreGraphics

1. Aspect fit/fill size

### 1.3. QuartzCore

1. Reflection
2. Transform 2D/3D

### 1.4. ImageIO

1. GIF

### 1.5. UIKit

1. UUID
2. Load UIImage with memory cache, format: PNG, JPEG, GIF
3. Snapshot for UIView
4. ...


## 2. Extensions

### 2.1. Page Scroll View

1. Page Scroll View
2. Prism Scroll View
3. Dock Scroll View
4. Cover Flow View

### 2.2. Scroll Refresh View

Four directions, five states supported.

| State Type   | Description                                             |
|--------------|---------------------------------------------------------|
| Default      | hidden                                                  |
| Visible      | pull to visible but cannot refresh yet                  |
| Will Refresh | dragging distance enough to refresh, but still dragging |
| Refreshing   | refreshing after drag end                               |
| Terminated   | no more data                                            |

### 2.3. Others

1. Swipe TableView Cell
2. Segmented Button / ScrollView
3. Particle View
4. Waterfall View
5. QRCode Image
6. Karaoke Label
7. ...


## 3. Utils

### 3.1. Data Structure

**Array, stack, queue, single chain table** for base data type: **int, float, pointer, ...**

> Base array for CGPoint

	// create a base array to store CGPoint data
	ds_array * array = ds_array_create(sizeof(CGPoint), 256);
	array->bk.assign = ds_assign_point_b;
	
	// add points to data item
	CGPoint point = CGPointMake(10, 20);
	ds_array_add(array, (const ds_type *)&point);
	
	// iterate through the array
	NSInteger offset;
	DS_FOR_EACH_ARRAY_ITEM(array, point, offset) {
		S9Log("[%d]: %@", offset, NSStringFromCGPoint(point));
	}
	
	// destroy the array
	ds_array_destroy(array);

### 3.2. XML

	NSString * file = @"aaaa.xml"; // saved in somewhere
	S9XMLDocument * doc = [[S9XMLDocument alloc] initWithContentsOfPath:file];
	
	// get the 1st child of root
	S9XMLElement * element = [doc childAtIndex:0];
	
	// get all grandson named "member" under the 2rd child named "meeting"
	NSArray * members = [element elementsWithPath:@"meeting[1]/member"];
	
	S9_FOR_EACH(members, element) {
		S9Log(@"name: %@, text: [%@]", element.name, element.text);
	}
	
	[doc release];

### 3.3. Finite State Machine

**Finite State Machine**, which has finitely several states in it,
only one of the states will be set as the current state in any time.

When the machine started up, we should build up all *states*
and their own *transitions* for changing from self to another state,
adding all states with their transitions one by one into the machine.

In each time period, the function `tick` of machine will be call,
this function will enumerate all transtions of the current state,
try to evaluate each of them,
while one transtion's function `evaluate` return *YES*,
then the machine will change to the new state by the transtion's target name.

When the machine stopped, it will run out from the current state,
and here we should remove all states.

If current state changed, the delegate function `fsm_machine_exit_state`
will be call with the old state, after that,
`fsm_machine_enter_state` will be call with the new state.
This mechanism can let you do something in the two opportune moments.

### 3.4. *MOF* data file format

**Memory Object File** format,
which allows you to save a dictionary object to a binary file,
it's faster to load a tiny binary file and parse it,
rather than an XML file.

> Save an NSDictionary object to '.mof' file

	NSString * dir = [[S9Client getInstance] temporaryDirectory];
	NSString * file = [dir stringByAppendingPathComponent:@"zzz.mof"];
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[dict setObject:@"moKy" forKey:@"name"];
	
	MOFTransformer * writer = [[MOFTransformer alloc] initWithObject:dict];
	[writer saveToFile:file];
	[writer release];

or just call

	MOFSave(dict, file);

> Load a '.mof' file to an NSDictionary object

	NSString * dir = [[S9Client getInstance] temporaryDirectory];
	NSString * file = [dir stringByAppendingPathComponent:@"zzz.mof"];
	
	MOFReader * reader = [[MOFReader alloc] initWithFile:file];
	NSObject * root = [reader root];
	[reader autorelease];
	
	NSDictionary * dict = (NSDictionary *)root;

or just call

	NSDictionary * dict = MOFLoad(file)

### 3.5. Translator

You can download language packs from remote, and save them in the caches directory with 'xxx.lproj' sub-directories.

After loaded them in your app, use `S9LocalizedString` to translate.

	// load language packs
	NSString * dir = [[S9Client getInstance] cachesDirectory];
	S9TranslatorScanLanguagePacks(dir);
	
	// translate 'key' to a string
	NSString * string = S9LocalizedString(@"key", @"comment");

### 3.6. Math

> The Four Arithmetic Operations

	NSString * string = @"(2 + 2) * 2 - 2 / 2";
	CGFloat result = CGFloatFromString(string);
	S9Log(@"%@ = %f", string, result);

### 3.7. Memory Cache

### 3.8. Scheduler & Actions

*Actions*:

1. CallFunc
2. CallBlock
3. DelayTime
4. Repeat(Forever)
5. Sequence
6. Spawn
7. ...


&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
*-- by [moKy][moky] @ Nov. 4, 2015*



[slanissue.com]: http://www.slanissue.com/ "Beijing Slanissue Technology Co., Ltd."

[slanissue.jpg]: http://www.slanissue.com/wp-content/uploads/2012/04/图片1.jpg "Slanissue"

[moky]: http://moky.github.com/ "About me"
