/*Copyright 2011 Catch.com
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/
//
//  SubEventSpeakersResultController.h
//  TEDxAlcatraz
//
//  Created by Nyceane on 2/17/11.
//  Copyright 2011 Catch.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubEventSpeakersResultController : UITableViewController {
	NSArray *speakers;
	NSArray *sessions;
	UISegmentedControl *switchFilter;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *switchFilter;

- (IBAction)switchFilter_Clicked;

- (IBAction)btnCurrent_Clicked;

@end