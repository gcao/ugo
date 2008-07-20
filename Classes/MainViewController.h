//
//  MainViewController.h
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BoardView.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UISegmentedControl*	_sizeSel;
	IBOutlet UIButton*				_goButton;
    IBOutlet UIScrollView*          _boardScrollView;
	
	BoardView*		_boardView;
}

- (IBAction) selectorChanged;
- (IBAction) goButton: (id) sender;

@end
