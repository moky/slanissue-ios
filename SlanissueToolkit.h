//
//  SlanissueToolkit.h
//  SlanissueToolkit
//
//  Created by Moky on 15-8-24.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

/**
 *  Dependences:
 *
 *      <Foundation.framework>
 *      <CoreFoundation.framework>
 *      <CoreGraphics.framework>
 *      <CoreImage.framework>
 *      <QuartzCore.framework>
 *      <UIKit.framework>
 *      <ImageIO.framework>
 *      <MobileCoreServices.framework>
 *
 */

/* debug */
#ifdef  NDEBUG
#elif   DEBUG
#define S9_DEBUG
#endif

#import "s9Macros.h"

//
//  DataStructure
//
#import "ds_base.h"
#import "ds_array.h"
#import "ds_stack.h"
#import "ds_queue.h"
#import "ds_chain.h"

//
//  FiniteStateMachine
//
#import "fsm_protocol.h"
#import "fsm_chain_table.h"
#import "fsm_machine.h"
#import "fsm_state.h"
#import "fsm_transition.h"

#import "FSMMachine.h"
#import "FSMAutoMachine.h"
#import "FSMState.h"
#import "FSMTransition.h"
#import "FSMFunctionTransition.h"
#import "FSMBlockTransition.h"

//
//  MemoryObjectFile
//
#import "mof_protocol.h"
#import "mof_data.h"

#import "MOFObject.h"
#import "MOFReader.h"
#import "MOFTransformer.h"

//
//  Foundation
//
#import "S9Object.h"
#import "S9Data.h"
#import "S9Number.h"
#import "S9String.h"
#import "S9Array.h"
#import "S9Dictionary.h"
#import "S9URL.h"
#import "S9Date.h"

//
//  CoreGraphics
//
#import "S9Geometry.h"

//
//  QuartzCore
//
#import "S9Layer.h"
#import "S9AffineTransform.h"
#import "S9View+Transform.h"
#import "S9View+Reflection.h"

//
//  ImageIO
//
#import "S9Image+GIF.h"

//
//  UIKit
//
#import "S9Device.h"
#import "S9Application.h"
#import "S9Image.h"
#import "S9Control.h"
#import "S9ViewController.h"
#import "S9View.h"
#import "S9WebView.h"
#import "S9ActionSheet.h"

//
//  UIKit Extensions
//
#import "S9RemoteController.h"
#import "S9SegmentedButton.h"
#import "S9SegmentedScrollView.h"
#import "S9SwipeTableViewCell.h"
#import "S9ParticleView.h"
#import "S9WaterfallView.h"
#import "S9WaterfallView+Layout.h"
#import "S9QRCodeImage.h"
// uikit_ext/refresh
#import "S9ScrollRefreshControlState.h"
#import "S9ScrollRefreshControlStateMachine.h"
#import "S9ScrollRefreshControl.h"
#import "S9ScrollRefreshView.h"
// uikit_ext/page
#import "S9PageScrollViewDataSource.h"
#import "S9PageScrollView.h"
#import "S9PrismScrollView.h"
#import "S9DockScrollView.h"
#import "S9CoverFlowView.h"


//
//  lang
//
#import "S9StringsFile.h"
#import "S9Translator.h"

//
//  sys
//
#import "S9Math.h"
#import "S9Client.h"
#import "S9MemoryCache.h"
#import "S9Texture.h"
#import "S9TextureCache.h"

//
//  timer
//
#import "S9Time.h"
#import "S9Tick.h"
#import "S9Scheduler.h"

//
//  action
//
#import "S9ActionManager.h"
#import "S9Action.h"
#import "S9FiniteTimeAction.h"
#import "S9ActionInstant.h"
#import "S9ActionInterval.h"


NSString * slanissueVersion(void);
