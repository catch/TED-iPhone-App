//
//  Conference.m
//  TEDxAlcatraz
//
//  Created by Peter Ma on 2/13/11.
//  Copyright 2011 Catch.com. All rights reserved.
//

#import "EventLogic.h"
#import "TEDxAlcatrazGlobal.h"
#import "WebServices.h"
#import "JSON.h"
#import "FusionTableReader.h"

@implementation EventLogic

+ (NSInteger)getEventVersion : (NSInteger)eventId
{
    NSDictionary *fusiontablecalls = [TEDxAlcatrazGlobal fusionTableDictionary];
                                    
    NSString *fusionquery = [NSString stringWithFormat:[fusiontablecalls objectForKey:@"GetEventVersion"], eventId];
    NSString *fusionquerycallback = [fusiontablecalls objectForKey:@"GetEventVersionCallBack"];    
	
    NSData *data = [FusionTableReader getSearchResultsByUrl:fusionquery type:fusionquerycallback];     

    NSArray *responseDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSUInteger ret = 0;
	if (responseDictionary != nil) {
		ret = [[[responseDictionary objectAtIndex:0] objectForKey:@"EventVersion"] intValue];
	}

	return ret;
}

+ (NSArray *)getEventSessionsFromWebService:(NSInteger)eventId
{
    NSDictionary *fusiontablecalls = [TEDxAlcatrazGlobal fusionTableDictionary];
    
    NSString *fusionquery = [NSString stringWithFormat:[fusiontablecalls objectForKey:@"GetEventSessions"], eventId];
    NSString *fusionquerycallback = [fusiontablecalls objectForKey:@"GetEventSessionsCallBack"];    
	
    NSData *data = [FusionTableReader getSearchResultsByUrl:fusionquery type:fusionquerycallback];     
    
    NSArray *responseDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:responseDictionary] forKey:[NSString stringWithFormat:@"%@%d", EVENT_SESSION_DATA, eventId]];
    
    DLog(@"Sessions:%@", responseDictionary);
    
	return responseDictionary;
}

+ (NSArray *)getEventSessionsFromCache:(NSInteger)eventId
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d", EVENT_SESSION_DATA, eventId]];
	NSArray *returnString = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	DLog(@"EventSession:%@", returnString);
	
	return returnString;
}


+ (NSArray *)getSpeakersByEventWebService:(NSInteger)eventId Version:(NSInteger)version
{
    NSDictionary *fusiontablecalls = [TEDxAlcatrazGlobal fusionTableDictionary];
    
    NSString *fusionquery = [NSString stringWithFormat:[fusiontablecalls objectForKey:@"GetEventSpeakers"], eventId];
    NSString *fusionquerycallback = [fusiontablecalls objectForKey:@"GetEventSpeakersCallBack"];    
	
    NSData *data = [FusionTableReader getSearchResultsByUrl:fusionquery type:fusionquerycallback];     
    
    NSArray *responseDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:responseDictionary] forKey:[NSString stringWithFormat:@"%@%d", EVENT_SPEAKER_DATA, eventId]];
	[[NSUserDefaults standardUserDefaults] setInteger:version forKey:EVENT_VERSION];
    
    DLog(@"Speakers:%@", responseDictionary);
    
	return responseDictionary;
}

+ (NSArray *)getSpeakersByEventFromCache:(NSInteger)eventId;
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d", EVENT_SPEAKER_DATA, eventId]];
	NSArray *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
	DLog(@"Speakers:%@", returnData);
	
	return returnData;
}

+(int)dateDiff:(NSDate*)firstday lastday:(NSDate*)lastday {
	NSDate *startDate = firstday;
	NSDate *endDate = lastday;
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	int days = [components day];
	return days;
}


+ (NSInteger)getCurrentSession:(NSArray *)sessions
{
	NSDate *currentTime = [NSDate date];
	
	NSInteger ret = 1;
	
	for(int i = 0; i<[sessions count]; i++)
	{
		if ([currentTime compare:[TEDxAlcatrazGlobal sessionTimeFromJSONData:[sessions objectAtIndex:i]]] > 0) {
			ret = [TEDxAlcatrazGlobal sessionFromJSONData:[sessions objectAtIndex:i]];
		}
	}
	
	return ret;
}

+ (NSString *)getSessionNameBySessionId:(NSInteger)session data:(NSArray *)sessions
{
	NSMutableString *ret = [NSMutableString stringWithFormat:@"Session %d", session];
	
	if(sessions != nil)
	{
		for (int i = 0; i < [sessions count]; i++) {
			if (session == [TEDxAlcatrazGlobal sessionIdFromJSONData:[sessions objectAtIndex:i]]) {
				[ret appendString: @": "];
				[ret appendString: [TEDxAlcatrazGlobal sessionNameFromJSONData:[sessions objectAtIndex:i]]];
			}
		}
	}
	
	return [NSString stringWithFormat:@"%@",ret];
}

+ (NSInteger)getRowsBySectionNumber : (NSArray *)data section : (NSInteger)Section
{
	NSInteger count = 0;
	for (int i = 0; i < [data count]; i++) {
		if ([TEDxAlcatrazGlobal sessionFromJSONData:[data objectAtIndex:i]] == Section + 1) {
			count++;
		}
	}
	return count;
}

+ (NSArray *)getSpeakersBySection : (NSArray *)data section : (NSInteger)Section
{
	NSMutableArray *returnData = [NSMutableArray arrayWithArray:data];
	for (int i = 0; i < [returnData count]; i++) {
		if ([TEDxAlcatrazGlobal sessionFromJSONData:[returnData objectAtIndex:i]] != Section + 1) {			
			[returnData removeObjectAtIndex:i];
			i--;
		}
	}
	return [NSArray arrayWithArray:returnData];
}
@end
