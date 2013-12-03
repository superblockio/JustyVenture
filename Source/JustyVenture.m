//
//  JustyVenture.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "JustyVenture.h"
#import "Command.h"
#import "Item.h"
#import "Exit.h"
#import "Container.h"

typedef enum {
    JVXMLRoomContext,
    JVXMLCommandsContext,
    JVXMLItemsContext,
    JVXMLMobsContext,
    JVXMLOuterContext
}JVXMLContext;

typedef enum {
    JVXMLSecondPluralityContext,
    JVXMLSecondConditionContext,
    JVXMLSecondExitContext,
    JVXMLSecondContainerContext,
    JVXMLSecondOuterContext
}JVXMLSecondContext;

typedef enum {
    JVIntroTypeReplace,
    JVIntroTypeAppend,
    JVIntroTypeIgnore
}JVIntroType;

typedef enum {
    JVVariableTypeBool,
    JVVariableTypeString,
    JVVariableTypeInt,
    JVVariableTypeFloat,
    JVVariableTypeDouble
}JVVariableType;

@interface JustyVenture () {
}

@property(nonatomic, assign) JVIntroType introType;
@property(nonatomic, strong) NSXMLParser *parser;
@property(nonatomic, strong) NSString *currentElementBody;
@property(nonatomic, strong) NSMutableArray *currentTags;
@property(nonatomic, strong) Room *currentRoomXML;
@property(nonatomic, strong) Command *currentCommandXML;
@property(nonatomic, strong) Item *currentItemXML;
@property(nonatomic, strong) Mob *currentMobXML;
@property(nonatomic, strong) Exit *currentExitXML;
@property(nonatomic, strong) Container *currentContainerXML;
@property(nonatomic, strong) NSString *currentConditionXML;
@property(nonatomic, strong) Player *currentPlayer;

@property (nonatomic, strong) NSMutableDictionary *rooms;
@property (nonatomic, strong) NSMutableDictionary *variables;
@property (nonatomic, strong) NSMutableDictionary *items;
@property (nonatomic, strong) NSMutableDictionary *mobs;
@property (nonatomic, strong) NSMutableDictionary *players;
@property (nonatomic, strong) NSMutableArray *commands;
@property (nonatomic, strong) NSMutableArray *dynamicCommands;

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *verb;
@property (nonatomic, assign) BOOL firstTag;
@property (nonatomic, assign) BOOL dynamic;

@end

@implementation JustyVenture
@synthesize delegate=_delegate;

static JustyVenture *_sharedState;

+ (JustyVenture*)mainVenture {
    @synchronized(self) {
        if (!_sharedState) {
            _sharedState = [[JustyVenture alloc] init];
        }
        return _sharedState;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.rooms = [[NSMutableDictionary alloc] init];
        self.variables = [[NSMutableDictionary alloc] init];
        self.items = [[NSMutableDictionary alloc] init];
        self.mobs = [[NSMutableDictionary alloc] init];
        self.commands = [[NSMutableArray alloc] init];
        self.dynamicCommands = [[NSMutableArray alloc] init];
        self.adventureTitle = @"Adventure!";
        self.currentPlayer = [[Player alloc] init];
        [self parseAdventureFiles];
    }
    return self;
}

- (void)parseAdventureFiles {
    NSString *directory = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Adventure Files/"];
    NSArray *adventureFiles = [self recursivePathsForResourcesOfType:@"jv" inDirectory:directory];
    for (NSString *jvPath in adventureFiles) {
        self.currentTags = [[NSMutableArray alloc] init];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:jvPath]];
        self.parser.delegate = self;
        [self.parser parse];
    }
}

- (NSString*)runUserInput:(NSString*)input {
    Room *currentRoom = [self.rooms objectForKey:self.currentPlayer.currentRoomName];
    self.promptText = @"What wouldst thou deau?";
    self.verb = [[input componentsSeparatedByString:@" "] objectAtIndex:0];
    self.subject = @"";
    
    if ([[input componentsSeparatedByString:@" "] count] > 1) {
        self.subject = [input substringFromIndex:self.verb.length + 1];
    }
    
    // First, check the room commands
    NSString *roomResult = [self RunCommands:[currentRoom commands] dynamicCommands:[currentRoom dynamicCommands]];
    if (roomResult != nil) return roomResult;
    
    // Next, check the fallback commands
    NSString *fallbackResult = [self RunCommands:self.commands dynamicCommands:self.dynamicCommands];
    if (fallbackResult != nil) return fallbackResult;
    
    // If we have no valid commands, give them the standard speil
    if (![self.subject isEqual: @""])return [NSString stringWithFormat:@"You attempt to %@ the %@ but it-What's wrong with you!? Why would you even try such a thing?! You need some serious HELP man...", self.verb, self.subject];
    return @"What you say?! Type HELP if you need it.";
}

// Taken and modified from: http://stackoverflow.com/questions/5836587/how-do-i-get-all-resource-paths-in-my-bundle-recursively-in-ios
- (NSArray *)recursivePathsForResourcesOfType:(NSString *)type inDirectory:(NSString *)directoryPath {
    
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    
    // Enumerators are recursive
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath];
    
    NSString *filePath;
    
    while ((filePath = [enumerator nextObject]) != nil){
        
        // If we have the right type of file, add it to the list
        // Make sure to prepend the directory path
        if([[filePath pathExtension] isEqualToString:type]){
            [filePaths addObject:[directoryPath stringByAppendingString:filePath]];
        }
    }
    
    return filePaths;
}

# pragma mark NSXMLParserDelegate methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.currentElementBody = @"";
    
    // If we're one of the top-level elements, do top-leveley stuff
    if ([self context] == JVXMLOuterContext) {
        
        // Room stuff
        if ([elementName caseInsensitiveCompare:@"Room"] == NSOrderedSame) {
            Room *room = [[Room alloc] init];
            if ([attributeDict objectForKey:@"name"] != nil) {
                [room setName:[attributeDict objectForKey:@"name"]];
            }
            else {
                NSLog(@"XML Error: We just came across a room without a name and that is never supposed to happen");
            }
            
            if ([attributeDict objectForKey:@"drop"] != nil) {
                if ([[attributeDict objectForKey:@"drop"] caseInsensitiveCompare:@"false"]) [room setAllowDrop:FALSE];
            }
            
            if ([attributeDict objectForKey:@"items"] != nil) {
                [room setItems:[self parseItems:[attributeDict objectForKey:@"items"] items:room.items]];
            }
            
            if ([attributeDict objectForKey:@"mobs"] != nil) {
                [room setMobs:[self parseMobs:[attributeDict objectForKey:@"mobs"] roomMobs:room.mobs]];
            }
            
            self.currentRoomXML = room;
        }
        
        // Intro stuff
        else if ([elementName caseInsensitiveCompare:@"Intro"] == NSOrderedSame) {
            
            // Replaces the first room's arrive text by default
            self.introType = JVIntroTypeReplace;
            if ([attributeDict objectForKey:@"type"] != nil) {
                NSString *type = [attributeDict objectForKey:@"type"];
                if ([type isEqualToString:@"append"]) {
                    self.introType = JVIntroTypeAppend;
                }
                else if ([type isEqualToString:@"replace"]) {
                    self.introType = JVIntroTypeReplace;
                }
                else if ([type isEqualToString:@"ignore"]) {
                    self.introType = JVIntroTypeIgnore;
                }
            }
            
            // Set the room name
            if ([attributeDict objectForKey:@"firstRoom"] != nil) {
                [self.currentPlayer setCurrentRoomName:[attributeDict objectForKey:@"firstRoom"]];
            }
            else {
                NSLog(@"XML Error: Intro tag does not contain firstRoom attribute!");
            }
        }
        
        // If this is the outmost tag, use its name attribute to define the name of the app
        else if ([elementName caseInsensitiveCompare:@"Adventure"] == NSOrderedSame) {
            if ([attributeDict objectForKey:@"name"] != nil) {
                self.adventureTitle = [attributeDict objectForKey:@"name"];
            }
        }
    }
    
    // If we're in a room or command tag, interpret each tag as a command
    if ([self context] == JVXMLRoomContext || [self context] == JVXMLCommandsContext) {
        if ([elementName caseInsensitiveCompare:@"Exit"] == NSOrderedSame) {
            Exit *exit = [[Exit alloc] init];
            
            // First, find all keywords associated with this command
            if ([attributeDict objectForKey:@"keywords"] != nil) {
                [exit setKeywords:[self parseAttribute:[attributeDict objectForKey:@"keywords"]]];
            }
            else {
                [exit setKeywords:[self parseAttribute:[attributeDict objectForKey:@"name"]]];
            }
            
            // Next the name
            if ([attributeDict objectForKey:@"name"] != nil) {
                [exit setName:[attributeDict objectForKey:@"name"]];
            } else {
                NSLog(@"XML Error: We just came across an exit without a name and that is never supposed to happen");
            }
            
            if ([attributeDict objectForKey:@"destination"] != nil) {
                [exit setDestination:[attributeDict objectForKey:@"destination"]];
            }
            else {
                NSLog(@"XML Error: We just came across an exit without a destination and that is never supposed to happen");
            }
            
            // And the plural short description
            if ([attributeDict objectForKey:@"lshort"] != nil) {
                [exit setLockDesc:[attributeDict objectForKey:@"lshort"]];
            }
            
            // Then the singular short description
            if ([attributeDict objectForKey:@"short"] != nil) {
                [exit setUnlockDesc:[attributeDict objectForKey:@"short"]];
            }
            else {
                [exit setUnlockDesc:[attributeDict objectForKey:@"name"]];
            }
            
            // And the plural long description
            if ([attributeDict objectForKey:@"llong"] != nil) {
                [exit setLockDescription:[attributeDict objectForKey:@"llong"]];
            }
            
            // Then the singular long description
            if ([attributeDict objectForKey:@"long"] != nil) {
                [exit setUnlockDescription:[attributeDict objectForKey:@"long"]];
            }
            
            // Then whether or not the exit shows up in a room
            if ([attributeDict objectForKey:@"hidden"] != nil) {
                if ([[attributeDict objectForKey:@"hidden"] caseInsensitiveCompare:@"true"] == NSOrderedSame) [exit setHidden:false];
            }
            
            // And whether it's locked
            if ([attributeDict objectForKey:@"locked"] != nil) {
                if ([[attributeDict objectForKey:@"locked"] caseInsensitiveCompare:@"true"] == NSOrderedSame) [exit setLocked:true];
            }
            
            self.currentExitXML = exit;
        }
        else if ([elementName caseInsensitiveCompare:@"Container"] == NSOrderedSame) {
            Container *container = [[Container alloc] init];
            
            // First, find all keywords associated with this command
            if ([attributeDict objectForKey:@"keywords"] != nil) {
                [container setKeywords:[self parseAttribute:[attributeDict objectForKey:@"keywords"]]];
            }
            else {
                [container setKeywords:[self parseAttribute:[attributeDict objectForKey:@"name"]]];
            }
            
            // Next the name
            if ([attributeDict objectForKey:@"name"] != nil) {
                [container setName:[attributeDict objectForKey:@"name"]];
            } else {
                NSLog(@"XML Error: We just came across a container without a name and that is never supposed to happen");
            }
            
            // And the plural short description
            if ([attributeDict objectForKey:@"lshort"] != nil) {
                [container setLockDesc:[attributeDict objectForKey:@"lshort"]];
            }
            
            // Then the singular short description
            if ([attributeDict objectForKey:@"short"] != nil) {
                [container setUnlockDesc:[attributeDict objectForKey:@"short"]];
            }
            else {
                [container setUnlockDesc:[attributeDict objectForKey:@"name"]];
            }
            
            // And the plural long description
            if ([attributeDict objectForKey:@"llong"] != nil) {
                [container setLockDescription:[attributeDict objectForKey:@"llong"]];
            }
            
            // Then the singular long description
            if ([attributeDict objectForKey:@"long"] != nil) {
                [container setUnlockDescription:[attributeDict objectForKey:@"long"]];
            }
            
            if ([attributeDict objectForKey:@"items"] != nil) {
                [container setItems:[self parseItems:[attributeDict objectForKey:@"items"] items:container.items]];
            }
            
            // Then whether or not the container shows up in a room
            if ([attributeDict objectForKey:@"hidden"] != nil) {
                if ([[attributeDict objectForKey:@"hidden"] caseInsensitiveCompare:@"true"] == NSOrderedSame) [container setHidden:false];
            }
            
            // And whether it's locked
            if ([attributeDict objectForKey:@"locked"] != nil) {
                if ([[attributeDict objectForKey:@"locked"] caseInsensitiveCompare:@"true"] == NSOrderedSame) [container setLocked:true];
            }
            
            self.currentContainerXML = container;
        }
        else if ([self secondContext] == JVXMLSecondExitContext) {
            Exit *exit = self.currentExitXML;
            
            if ([elementName caseInsensitiveCompare:@"Locked"] == NSOrderedSame) {
                if ([attributeDict objectForKey:@"short"] != nil) {
                    [exit setLockDesc:[attributeDict objectForKey:@"short"]];
                }
                
                if ([attributeDict objectForKey:@"long"] != nil) {
                    [exit setLockDescription:[attributeDict objectForKey:@"long"]];
                }
            }
            
            if ([elementName caseInsensitiveCompare:@"Unlocked"] == NSOrderedSame) {
                if ([attributeDict objectForKey:@"short"] != nil) {
                    [exit setUnlockDesc:[attributeDict objectForKey:@"short"]];
                }
                
                if ([attributeDict objectForKey:@"long"] != nil) {
                    [exit setUnlockDescription:[attributeDict objectForKey:@"long"]];
                }
            }
            
            self.currentExitXML = exit;
        }
        else if ([self secondContext] == JVXMLSecondContainerContext) {
            Container *container = self.currentContainerXML;
            
            if ([elementName caseInsensitiveCompare:@"Locked"] == NSOrderedSame) {
                if ([attributeDict objectForKey:@"short"] != nil) {
                    [container setLockDesc:[attributeDict objectForKey:@"short"]];
                }
                
                if ([attributeDict objectForKey:@"long"] != nil) {
                    [container setLockDescription:[attributeDict objectForKey:@"long"]];
                }
            }
            
            if ([elementName caseInsensitiveCompare:@"Unlocked"] == NSOrderedSame) {
                if ([attributeDict objectForKey:@"short"] != nil) {
                    [container setUnlockDesc:[attributeDict objectForKey:@"short"]];
                }
                
                if ([attributeDict objectForKey:@"long"] != nil) {
                    [container setUnlockDescription:[attributeDict objectForKey:@"long"]];
                }
            }
            
            self.currentContainerXML = container;
        }
        else if ([self secondContext] == JVXMLSecondConditionContext) {
            NSString *condition = @"Else";
            
            
            // Now find the subjects (if any)
            if ([attributeDict objectForKey:@"condition"] != nil) {
                condition = [attributeDict objectForKey:@"condition"];
            }
            
            self.currentConditionXML = condition;
        }
        else if ([self secondContext] == JVXMLSecondOuterContext) {
            Command *command = [[Command alloc] init];
            self.dynamic = false;
            
            // First, find all verbs associated with this command
            NSMutableArray *verbs = [NSMutableArray array];
            [verbs addObject:elementName];
            if ([attributeDict objectForKey:@"alt"] != nil) {
                [verbs addObjectsFromArray:[self parseAttribute:[attributeDict objectForKey:@"alt"]]];
            }
            [command setVerbs:verbs];
            
            // Now find the subjects (if any)
            if ([attributeDict objectForKey:@"subject"] != nil) {
                [command setSubjects:[self parseAttribute:[attributeDict objectForKey:@"subject"]]];
            }
            
            // Check to see if this should be considered a dynamic command
            if ([attributeDict objectForKey:@"dynamic"] != nil) {
                if ([[attributeDict objectForKey:@"dynamic"] caseInsensitiveCompare:@"true"] == NSOrderedSame) self.dynamic = true;
            }
            
            // Finally, see if it's an internal command or not
            if ([attributeDict objectForKey:@"internal"] != nil) {
                command.internal = [[[self parseAttribute:[attributeDict objectForKey:@"internal"]] objectAtIndex:0] boolValue];
            }
            else {
                // The Arrive command is internal by default
                if([elementName caseInsensitiveCompare:@"Arrive"] == NSOrderedSame) {
                    command.internal = true;
                }
                // All other commands are external by default
                else {
                    command.internal = false;
                }
            }
            
            self.currentCommandXML = command;
        }
    }
    
    // If we're in an item tag, interpret each tag as an item
    if ([self context] == JVXMLItemsContext) {
        Item *item = [[Item alloc] init];
        
        // If we're setting a singular or plural look text, also check to see if they have attributes in them.
        if ([self secondContext] == JVXMLSecondPluralityContext) {
            item = self.currentItemXML;
            
            if ([elementName caseInsensitiveCompare:@"Single"] == NSOrderedSame) {
                if ([attributeDict objectForKey:@"name"] != nil) {
                    [item setSingularName:[attributeDict objectForKey:@"name"]];
                }
                
                if ([attributeDict objectForKey:@"short"] != nil) {
                    [item setSingularDesc:[attributeDict objectForKey:@"short"]];
                }
                
                if ([attributeDict objectForKey:@"long"] != nil) {
                    [item setSingularDescription:[attributeDict objectForKey:@"long"]];
                }
            }
            
            if ([elementName caseInsensitiveCompare:@"Plural"] == NSOrderedSame) {
                if ([attributeDict objectForKey:@"name"] != nil) {
                    [item setPluralName:[attributeDict objectForKey:@"name"]];
                }
                
                if ([attributeDict objectForKey:@"short"] != nil) {
                    [item setPluralDesc:[attributeDict objectForKey:@"short"]];
                }
                
                if ([attributeDict objectForKey:@"long"] != nil) {
                    [item setPluralDescription:[attributeDict objectForKey:@"long"]];
                }
            }
        }
        else {
            // First, find all keywords associated with this command
            if ([attributeDict objectForKey:@"keywords"] != nil) {
                [item setKeywords:[self parseAttribute:[attributeDict objectForKey:@"keywords"]]];
            }
            else {
                [item setKeywords:[self parseAttribute:elementName]];
            }
            
            // Next the singular descriptive name
            if ([attributeDict objectForKey:@"name"] != nil) {
                [item setSingularName:[attributeDict objectForKey:@"name"]];
            }
            else {
                [item setSingularName:elementName];
            }
            
            // And the plural descriptive name
            if ([attributeDict objectForKey:@"pname"] != nil) {
                [item setPluralName:[attributeDict objectForKey:@"pname"]];
            }
            
            // Then the singular short description
            if ([attributeDict objectForKey:@"short"] != nil) {
                [item setSingularDesc:[attributeDict objectForKey:@"short"]];
            }
            else {
                [item setSingularDesc:@"@name;"];
            }
            
            // And the plural short description
            if ([attributeDict objectForKey:@"pshort"] != nil) {
                [item setPluralDesc:[attributeDict objectForKey:@"pshort"]];
            }
            
            // Then the singular long description
            if ([attributeDict objectForKey:@"long"] != nil) {
                [item setSingularDescription:[attributeDict objectForKey:@"long"]];
            }
            
            // And the plural long description
            if ([attributeDict objectForKey:@"plong"] != nil) {
                [item setPluralDescription:[attributeDict objectForKey:@"plong"]];
            }
            
            // Then the whether or not the item shows up in a room
            if ([attributeDict objectForKey:@"hidden"] != nil) {
                if ([[attributeDict objectForKey:@"hidden"] caseInsensitiveCompare:@"true"] == NSOrderedSame) [item setHidden:false];
            }
            
            // And whether it's possible to drop the item once you pick it up
            if ([attributeDict objectForKey:@"drop"] != nil) {
                if ([[attributeDict objectForKey:@"drop"] caseInsensitiveCompare:@"false"] == NSOrderedSame) [item setCanDrop:false];
            }
            
            // Finally, set the internal name for the item
            [item setName:elementName];
        }
        
        self.currentItemXML = item;
    }
    
    // If we're in a mob tag, interpret each tag as a mob
    if ([self context] == JVXMLMobsContext) {
        Mob *mob = [[Mob alloc] init];
        
        // If we're setting a singular or plural look text, also check to see if they have attributes in them.
        if ([self secondContext] == JVXMLSecondPluralityContext) {
            mob = self.currentMobXML;
            
            if ([elementName caseInsensitiveCompare:@"Single"] == NSOrderedSame) {
                if ([attributeDict objectForKey:@"name"] != nil) {
                    [mob setSingularName:[attributeDict objectForKey:@"name"]];
                }
                
                if ([attributeDict objectForKey:@"short"] != nil) {
                    [mob setSingularDesc:[attributeDict objectForKey:@"short"]];
                }
                
                if ([attributeDict objectForKey:@"long"] != nil) {
                    [mob setSingularDescription:[attributeDict objectForKey:@"long"]];
                }
            }
            
            if ([elementName caseInsensitiveCompare:@"Plural"] == NSOrderedSame) {
                if ([attributeDict objectForKey:@"name"] != nil) {
                    [mob setPluralName:[attributeDict objectForKey:@"name"]];
                }
                
                if ([attributeDict objectForKey:@"short"] != nil) {
                    [mob setPluralDesc:[attributeDict objectForKey:@"short"]];
                }
                
                if ([attributeDict objectForKey:@"long"] != nil) {
                    [mob setPluralDescription:[attributeDict objectForKey:@"long"]];
                }
            }
        }
        else {
            // First, find all keywords associated with this command
            if ([attributeDict objectForKey:@"keywords"] != nil) {
                [mob setKeywords:[self parseAttribute:[attributeDict objectForKey:@"keywords"]]];
            }
            else {
                [mob setKeywords:[self parseAttribute:elementName]];
            }
            
            // Next the singular descriptive name
            if ([attributeDict objectForKey:@"name"] != nil) {
                [mob setSingularName:[attributeDict objectForKey:@"name"]];
            }
            else {
                [mob setSingularName:elementName];
            }
            
            // And the plural descriptive name
            if ([attributeDict objectForKey:@"pname"] != nil) {
                [mob setPluralName:[attributeDict objectForKey:@"pname"]];
            }
            
            // Then the singular short description
            if ([attributeDict objectForKey:@"short"] != nil) {
                [mob setSingularDesc:[attributeDict objectForKey:@"short"]];
            }
            else {
                [mob setSingularDesc:@"@name;"];
            }
            
            // And the plural short description
            if ([attributeDict objectForKey:@"pshort"] != nil) {
                [mob setPluralDesc:[attributeDict objectForKey:@"pshort"]];
            }
            
            // Then the singular long description
            if ([attributeDict objectForKey:@"long"] != nil) {
                [mob setSingularDescription:[attributeDict objectForKey:@"long"]];
            }
            
            // And the plural long description
            if ([attributeDict objectForKey:@"plong"] != nil) {
                [mob setPluralDescription:[attributeDict objectForKey:@"plong"]];
            }
            
            // Then the whether or not the mob shows up in a room
            if ([attributeDict objectForKey:@"hidden"] != nil) {
                if ([[attributeDict objectForKey:@"hidden"] caseInsensitiveCompare:@"true"] == NSOrderedSame) [mob setHidden:true];
            }
            
            // And whether it's possible to drop the mob once you pick it up
            if ([attributeDict objectForKey:@"talk"] != nil) {
                if ([[attributeDict objectForKey:@"talk"] caseInsensitiveCompare:@"true"] == NSOrderedSame) [mob setCanTalk:true];
            }
            
            // And whether it's possible to drop the mob once you pick it up
            if ([attributeDict objectForKey:@"hold"] != nil) {
                if ([[attributeDict objectForKey:@"hold"] caseInsensitiveCompare:@"true"] == NSOrderedSame) [mob setCanHold:true];
            }
            
            // Finally, set the internal name for the mob
            [mob setName:elementName];
        }
        
        self.currentMobXML = mob;
    }
    
    [self.currentTags addObject:elementName];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementBody = [self.currentElementBody stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [self.currentTags removeLastObject];
    
    // First, remove leading linebreak if there is one because that gunk is ill and we need to be able to have a new line
    // in the XML for formatting reasons n stuff
    if ([[self.currentElementBody substringToIndex:1] isEqualToString:@"\n"]) {
        self.currentElementBody = [self.currentElementBody substringFromIndex:1];
    }
    
    // Next, remove ending linebreak if there is one because that gunk is ill and we need to be able to have a new line
    // in the XML for formatting reasons n stuff
    if ([[self.currentElementBody substringFromIndex:self.currentElementBody.length - 1] isEqualToString:@"\n"]) {
        self.currentElementBody = [self.currentElementBody substringToIndex:self.currentElementBody.length - 1];
    }
    
    // Use our context to figure out what to do with the body (text)
    
    // If this was one of the top-level elements (room, intro, commands, etc) treat it as such
    if ([self context] == JVXMLOuterContext) {
        // Handle room
        if ([elementName caseInsensitiveCompare:@"Room"] == NSOrderedSame) {
            [self.rooms setObject:self.currentRoomXML forKey:self.currentRoomXML.name];
        }
        
        // Handle intro
        if ([elementName caseInsensitiveCompare:@"Intro"] == NSOrderedSame) {
            self.introText = self.currentElementBody;
        }
    }
    
    else if ([self context] == JVXMLRoomContext) {
        if ([elementName caseInsensitiveCompare:@"Exit"] == NSOrderedSame) {
            if ([self.currentExitXML.unlockLook isEqualToString:@""]) [self.currentExitXML setUnlockLook:self.currentElementBody];
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary addEntriesFromDictionary:self.currentRoomXML.exits];
            [dictionary setObject:self.currentExitXML forKey:self.currentExitXML.name];
            [self.currentRoomXML setExits:dictionary];
        }
        else if ([elementName caseInsensitiveCompare:@"Container"] == NSOrderedSame) {
            if ([self.currentContainerXML.unlockLook isEqualToString:@""]) [self.currentContainerXML setUnlockLook:self.currentElementBody];
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary addEntriesFromDictionary:self.currentRoomXML.containers];
            [dictionary setObject:self.currentContainerXML forKey:self.currentContainerXML.name];
            [self.currentRoomXML setContainers:dictionary];
        }
        else if ([self secondContext] == JVXMLSecondExitContext) {
            // Set the look text for the item.
            if ([elementName caseInsensitiveCompare:@"Locked"] == NSOrderedSame) {
                [self.currentExitXML setLockLook:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Unlocked"] == NSOrderedSame) {
                [self.currentExitXML setUnlockLook:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Unlock"] == NSOrderedSame) {
                [self.currentExitXML setUnlockText:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Key"] == NSOrderedSame) {
                [self.currentExitXML setBadKey:self.currentElementBody];
            }
        }
        else if ([self secondContext] == JVXMLSecondContainerContext) {
            // Set the look text for the item.
            if ([elementName caseInsensitiveCompare:@"Locked"] == NSOrderedSame) {
                [self.currentContainerXML setLockLook:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Unlocked"] == NSOrderedSame) {
                [self.currentContainerXML setUnlockLook:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Unlock"] == NSOrderedSame) {
                [self.currentContainerXML setUnlockText:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Empty"] == NSOrderedSame) {
                [self.currentContainerXML setEmptyText:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Key"] == NSOrderedSame) {
                [self.currentContainerXML setBadKey:self.currentElementBody];
            }
        }
        else if ([self secondContext] == JVXMLSecondConditionContext) {
            // Set the look text for the item.
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            if ([elementName caseInsensitiveCompare:@"If"] == NSOrderedSame) {
                [dictionary addEntriesFromDictionary:self.currentCommandXML.result];
                [dictionary setObject:self.currentElementBody forKey:self.currentConditionXML];
                [self.currentCommandXML setResult:dictionary];
            } else if ([elementName caseInsensitiveCompare:@"Else"] == NSOrderedSame) {
                [dictionary addEntriesFromDictionary:self.currentCommandXML.result];
                [dictionary setObject:self.currentElementBody forKey:@"Else"];
                [self.currentCommandXML setResult:dictionary];
            }
        }
        else if ([self secondContext] == JVXMLSecondOuterContext) {
            if ([self.currentCommandXML.result objectForKey:@"Else"] == nil)
            {
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                [dictionary addEntriesFromDictionary:self.currentCommandXML.result];
                [dictionary setObject:self.currentElementBody forKey:@"Else"];
                [self.currentCommandXML setResult:dictionary];
            }
            if (self.dynamic) [self.currentRoomXML setDynamicCommands:[self.currentRoomXML.dynamicCommands arrayByAddingObject:self.currentCommandXML]];
            else [self.currentRoomXML setCommands:[self.currentRoomXML.commands arrayByAddingObject:self.currentCommandXML]];
        }
    }
    
    else if ([self context] == JVXMLCommandsContext) {
        if ([self secondContext] == JVXMLSecondConditionContext) {
            // Set the look text for the item.
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            if ([elementName caseInsensitiveCompare:@"If"] == NSOrderedSame) {
                [dictionary addEntriesFromDictionary:self.currentCommandXML.result];
                [dictionary setObject:self.currentElementBody forKey:self.currentConditionXML];
                [self.currentCommandXML setResult:dictionary];
            } else if ([elementName caseInsensitiveCompare:@"Else"] == NSOrderedSame) {
                [dictionary addEntriesFromDictionary:self.currentCommandXML.result];
                [dictionary setObject:self.currentElementBody forKey:@"Else"];
                [self.currentCommandXML setResult:dictionary];
            }
        }
        else if ([self secondContext] == JVXMLSecondOuterContext) {
            if ([self.currentCommandXML.result objectForKey:@"Else"] == nil)
            {
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                [dictionary addEntriesFromDictionary:self.currentCommandXML.result];
                [dictionary setObject:self.currentElementBody forKey:@"Else"];
                [self.currentCommandXML setResult:dictionary];
            }
            if (self.dynamic) [self.dynamicCommands addObject:self.currentCommandXML];
            else [self.commands addObject:self.currentCommandXML];
        }
    }
    
    else if ([self context] == JVXMLItemsContext) {
        if ([self secondContext] == JVXMLSecondOuterContext) {
            if ([self.currentItemXML.singularLook isEqualToString:@""]) [self.currentItemXML setSingularLook:self.currentElementBody];
            [self.items setObject:self.currentItemXML forKey:self.currentItemXML.name];
        }
        else if ([self secondContext] == JVXMLSecondPluralityContext) {
            // Set the look text for the item.
            if ([elementName caseInsensitiveCompare:@"Single"] == NSOrderedSame) {
                [self.currentItemXML setSingularLook:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Plural"] == NSOrderedSame) {
                [self.currentItemXML setPluralLook:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Get"] == NSOrderedSame) {
                [self.currentItemXML setGetText:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Drop"] == NSOrderedSame) {
                [self.currentItemXML setDropText:self.currentElementBody];
            }
        }
    }
    
    else if ([self context] == JVXMLMobsContext) {
        if ([self secondContext] == JVXMLSecondOuterContext) {
            if ([self.currentMobXML.singularLook isEqualToString:@""]) [self.currentMobXML setSingularLook:self.currentElementBody];
            [self.mobs setObject:self.currentMobXML forKey:self.currentMobXML.name];
        }
        else if ([self secondContext] == JVXMLSecondPluralityContext) {
            // Set the look text for the mob.
            if ([elementName caseInsensitiveCompare:@"Single"] == NSOrderedSame) {
                [self.currentMobXML setSingularLook:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Plural"] == NSOrderedSame) {
                [self.currentMobXML setPluralLook:self.currentElementBody];
            } else if ([elementName caseInsensitiveCompare:@"Talk"] == NSOrderedSame) {
                [self.currentMobXML setTalkText:self.currentElementBody];
            }
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // We have to do the intro text here because the room might not be loaded when the intro tag is first read
    Room *firstRoom = [self.rooms objectForKey:self.currentPlayer.currentRoomName];
    if (self.introType != JVIntroTypeReplace) {
        for (int i = 0; i < firstRoom.commands.count; i++) {
            if ([[firstRoom.commands objectAtIndex:i] respondsToInternalName:@"arrive"]) {
                NSString *arrive = [self CheckConditions:[[firstRoom.commands objectAtIndex:i] result]];
                if (self.introType == JVIntroTypeAppend) {
                    self.introText = [self.introText stringByAppendingString:[self JustinTimeInterpret:arrive]];
                }
                else {
                    self.introText = [self JustinTimeInterpret:arrive];
                }
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XML parsing failed with error: %@", parseError);
}


- (NSArray*)parseAttribute:(NSString*)attribute {
    // See if it's a list or just a single thing
    // (first, get rid of leading whitespace)
    while ([[attribute substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        attribute = [attribute substringFromIndex:1];
    }
    while ([attribute rangeOfString:@"[ "].location != NSNotFound) {
        attribute = [attribute stringByReplacingOccurrencesOfString:@"[ " withString:@"["];
    }
    while ([attribute rangeOfString:@", "].location != NSNotFound) {
        attribute = [attribute stringByReplacingOccurrencesOfString:@", " withString:@","];
    }
    if ([attribute length] < 1) {
        return [NSArray array];
    }
    else if ([[attribute substringToIndex:1] isEqualToString:@"["]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[attribute componentsSeparatedByString:@","]];
        NSString *firstThing = [[array objectAtIndex:0] substringFromIndex:1];
        NSString *lastThing = [[array lastObject] substringToIndex:[[array lastObject] length] -1];
        [array replaceObjectAtIndex:0 withObject:firstThing];
        [array replaceObjectAtIndex:(array.count - 1) withObject:lastThing];
        return array;
    }
    else {
        return @[attribute];
    }
    return nil;
}

- (NSMutableArray*)parseMobs:(NSString*)mobList roomMobs:(NSMutableArray*)mobs {
    // See if it's a list or just a single thing
    // (first, get rid of leading whitespace)
    while ([[mobList substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        mobList = [mobList substringFromIndex:1];
    }
    while ([mobList rangeOfString:@"[ "].location != NSNotFound) {
        mobList = [mobList stringByReplacingOccurrencesOfString:@"[ " withString:@"["];
    }
    while ([mobList rangeOfString:@"( "].location != NSNotFound) {
        mobList = [mobList stringByReplacingOccurrencesOfString:@"( " withString:@"("];
    }
    while ([mobList rangeOfString:@", "].location != NSNotFound) {
        mobList = [mobList stringByReplacingOccurrencesOfString:@", " withString:@","];
    }
    while ([mobList rangeOfString:@"; "].location != NSNotFound) {
        mobList = [mobList stringByReplacingOccurrencesOfString:@"; " withString:@";"];
    }
    if ([mobList length] < 1) {
        return mobs;
    }
    else if ([[mobList substringToIndex:1] isEqualToString:@"["]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[mobList componentsSeparatedByString:@";"]];
        NSString *firstThing = [[array objectAtIndex:0] substringFromIndex:1];
        NSString *lastThing = [[array lastObject] substringToIndex:[[array lastObject] length] -1];
        [array replaceObjectAtIndex:0 withObject:firstThing];
        [array replaceObjectAtIndex:(array.count - 1) withObject:lastThing];
        for (int i=0; i<array.count; i++) {
            NSString *arrayMobName = [array objectAtIndex:i];
            if ([[arrayMobName substringToIndex:1] isEqualToString:@"("]) {
                NSMutableArray *mobArray = [NSMutableArray arrayWithArray:[arrayMobName componentsSeparatedByString:@","]];
                NSString *mobName = [[mobArray objectAtIndex:0] substringFromIndex:1];
                if ([self.mobs objectForKey:mobName] != nil) {
                    NSString *quantity = [[mobArray lastObject] substringToIndex:[[mobArray lastObject] length] -1];
                    Mob *newMob = [[Mob alloc] initWithMob:[self.mobs objectForKey:mobName]];
                    for (int j=0; j<[quantity intValue]; j++) {
                        [mobs addObject:newMob];
                    }
                }
            }
            else if ([self.mobs objectForKey:arrayMobName] != nil) {
                Mob *newMob = [[Mob alloc] initWithMob:[self.mobs objectForKey:arrayMobName]];
                [mobs addObject:newMob];
            }
        }
    }
    else if ([[mobList substringToIndex:1] isEqualToString:@"("]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[mobList componentsSeparatedByString:@","]];
        NSString *mobName = [[array objectAtIndex:0] substringFromIndex:1];
        if ([self.mobs objectForKey:mobName] != nil) {
            NSString *quantity = [[array lastObject] substringToIndex:[[array lastObject] length] -1];
            Mob *newMob = [[Mob alloc] initWithMob:[self.mobs objectForKey:mobName]];
            for (int j=0; j<[quantity intValue]; j++) {
                [mobs addObject:newMob];
            }
        }
    }
    else if ([self.mobs objectForKey:mobList] != nil) {
        Mob *newMob = [[Mob alloc] initWithMob:[self.mobs objectForKey:mobList]];
        [mobs addObject:newMob];
    }
    
    return mobs;
}

- (NSMutableDictionary*)parseItems:(NSString*)itemList items:(NSMutableDictionary*)items {
    // See if it's a list or just a single thing
    // (first, get rid of leading whitespace)
    while ([[itemList substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]) {
        itemList = [itemList substringFromIndex:1];
    }
    while ([itemList rangeOfString:@"[ "].location != NSNotFound) {
        itemList = [itemList stringByReplacingOccurrencesOfString:@"[ " withString:@"["];
    }
    while ([itemList rangeOfString:@"( "].location != NSNotFound) {
        itemList = [itemList stringByReplacingOccurrencesOfString:@"( " withString:@"("];
    }
    while ([itemList rangeOfString:@", "].location != NSNotFound) {
        itemList = [itemList stringByReplacingOccurrencesOfString:@", " withString:@","];
    }
    while ([itemList rangeOfString:@"; "].location != NSNotFound) {
        itemList = [itemList stringByReplacingOccurrencesOfString:@"; " withString:@";"];
    }
    if ([itemList length] < 1) {
        return items;
    }
    else if ([[itemList substringToIndex:1] isEqualToString:@"["]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[itemList componentsSeparatedByString:@";"]];
        NSString *firstThing = [[array objectAtIndex:0] substringFromIndex:1];
        NSString *lastThing = [[array lastObject] substringToIndex:[[array lastObject] length] -1];
        [array replaceObjectAtIndex:0 withObject:firstThing];
        [array replaceObjectAtIndex:(array.count - 1) withObject:lastThing];
        for (int i=0; i<array.count; i++) {
            NSString *arrayItemName = [array objectAtIndex:i];
            if ([[arrayItemName substringToIndex:1] isEqualToString:@"("]) {
                NSMutableArray *itemArray = [NSMutableArray arrayWithArray:[arrayItemName componentsSeparatedByString:@","]];
                NSString *itemName = [[itemArray objectAtIndex:0] substringFromIndex:1];
                if ([self.items objectForKey:itemName] != nil) {
                    NSString *quantity = [[itemArray lastObject] substringToIndex:[[itemArray lastObject] length] -1];
                    Item *newItem = [[Item alloc] initWithItem:[self.items objectForKey:itemName]];
                    Item *oldItem = [items objectForKey:itemName];
                    [newItem setQuantity:[quantity intValue]];
                    if (oldItem == nil) [items setObject:newItem forKey:itemName];
                    else {
                        [newItem setQuantity:newItem.quantity + oldItem.quantity];
                        [items setObject:newItem forKey:itemName];
                    }
                }
            }
            else if ([self.items objectForKey:arrayItemName] != nil) {
                Item *newItem = [[Item alloc] initWithItem:[self.items objectForKey:arrayItemName]];
                Item *oldItem = [items objectForKey:arrayItemName];
                if (oldItem == nil) [items setObject:newItem forKey:arrayItemName];
                else {
                    [newItem setQuantity:oldItem.quantity + 1];
                    [items setObject:newItem forKey:arrayItemName];
                }
            }
        }
    }
    else if ([[itemList substringToIndex:1] isEqualToString:@"("]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[itemList componentsSeparatedByString:@","]];
        NSString *itemName = [[array objectAtIndex:0] substringFromIndex:1];
        if ([self.items objectForKey:itemName] != nil) {
            NSString *quantity = [[array lastObject] substringToIndex:[[array lastObject] length] -1];
            Item *newItem = [[Item alloc] initWithItem:[self.items objectForKey:itemName]];
            Item *oldItem = [items objectForKey:itemName];
            [newItem setQuantity:[quantity intValue]];
            if (oldItem == nil) [items setObject:newItem forKey:itemName];
            else {
                [newItem setQuantity:newItem.quantity + oldItem.quantity];
                [items setObject:newItem forKey:itemName];
            }
        }
    }
    else if ([self.items objectForKey:itemList] != nil) {
        Item *newItem = [[Item alloc] initWithItem:[self.items objectForKey:itemList]];
        Item *oldItem = [items objectForKey:itemList];
        if (oldItem == nil) [items setObject:newItem forKey:itemList];
        else {
            [newItem setQuantity:oldItem.quantity + 1];
            [items setObject:newItem forKey:itemList];
        }
    }
    
    return items;
}

- (JVXMLContext)context {
    if (self.currentTags.count < 2) {
        return JVXMLOuterContext;
    }
    else if ([[self.currentTags objectAtIndex:1] caseInsensitiveCompare:@"Room"] == NSOrderedSame) {
        return JVXMLRoomContext;
    }
    else if ([[self.currentTags objectAtIndex:1] caseInsensitiveCompare:@"Commands"] == NSOrderedSame) {
        return JVXMLCommandsContext;
    }
    else if ([[self.currentTags objectAtIndex:1] caseInsensitiveCompare:@"Items"] == NSOrderedSame) {
        return JVXMLItemsContext;
    }else if ([[self.currentTags objectAtIndex:1] caseInsensitiveCompare:@"Mobs"] == NSOrderedSame) {
        return JVXMLMobsContext;
    }
    return JVXMLOuterContext;
}

- (JVXMLSecondContext)secondContext {
    if (self.currentTags.count < 3) {
        return JVXMLSecondOuterContext;
    }
    else if ([[self.currentTags objectAtIndex:2] caseInsensitiveCompare:@"Exit"] == NSOrderedSame) {
        return JVXMLSecondExitContext;
    }
    else if ([[self.currentTags objectAtIndex:2] caseInsensitiveCompare:@"Container"] == NSOrderedSame) {
        return JVXMLSecondContainerContext;
    }
    else if ([[self.currentTags objectAtIndex:1] caseInsensitiveCompare:@"Room"] == NSOrderedSame) {
        return JVXMLSecondConditionContext;
    }
    else if ([[self.currentTags objectAtIndex:1] caseInsensitiveCompare:@"Commands"] == NSOrderedSame) {
        return JVXMLSecondConditionContext;
    }
    else if ([[self.currentTags objectAtIndex:1] caseInsensitiveCompare:@"Items"] == NSOrderedSame) {
        return JVXMLSecondPluralityContext;
    }else if ([[self.currentTags objectAtIndex:1] caseInsensitiveCompare:@"Mobs"] == NSOrderedSame) {
        return JVXMLSecondPluralityContext;
    }
    return JVXMLSecondOuterContext;
}

- (NSMutableArray*)GenerateDynamicCommands:(NSArray*)dynamicCommands tempCommands:(NSMutableArray*)tempCommands {
    Room *currentRoom = [self.rooms objectForKey:self.currentPlayer.currentRoomName];
    
    for (int i = 0; i < dynamicCommands.count; i++) {
        Command *command = [dynamicCommands objectAtIndex:i];
        if ([command respondsToVerb:self.verb]) {
            if ([command respondsToVerb:self.verb subject:@"@items;"]) {
                for(id key in currentRoom.items) {
                    NSMutableArray *subjects = [NSMutableArray array];
                    Item *item = [currentRoom.items objectForKey:key];
                    [subjects addObjectsFromArray:item.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
                for(id bley in currentRoom.containers) {
                    Container *container = [currentRoom.containers objectForKey:bley];
                    if (!container.locked){
                        for(id key in container.items) {
                            NSMutableArray *subjects = [NSMutableArray array];
                            Item *item = [container.items objectForKey:key];
                            [subjects addObjectsFromArray:item.keywords];
                            Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                            [tempCommands addObject:newCommand];
                        }
                    }
                }
            }
            
            if ([command respondsToVerb:self.verb subject:@"@inv;"]) {
                for(id key in self.currentPlayer.items) {
                    NSMutableArray *subjects = [NSMutableArray array];
                    Item *item = [self.currentPlayer.items objectForKey:key];
                    [subjects addObjectsFromArray:item.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
            }
            
            if ([command respondsToVerb:self.verb subject:@"@exits;"]) {
                for(id key in currentRoom.exits) {
                    NSMutableArray *subjects = [NSMutableArray array];
                    Exit *exit = [currentRoom.exits objectForKey:key];
                    [subjects addObjectsFromArray:exit.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
            }
            
            if ([command respondsToVerb:self.verb subject:@"@containers;"]) {
                for(id key in currentRoom.containers) {
                    NSMutableArray *subjects = [NSMutableArray array];
                    Container *container = [currentRoom.containers objectForKey:key];
                    [subjects addObjectsFromArray:container.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
            }
            
            if ([command respondsToVerb:self.verb subject:@"@mobs;"]) {
                for(int i = 0; i < currentRoom.mobs.count; i++) {
                    NSMutableArray *subjects = [NSMutableArray array];
                    Mob *mob = [currentRoom.mobs objectAtIndex:i];
                    [subjects addObjectsFromArray:mob.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
            }
            
            for(id key in currentRoom.items) {
                NSMutableArray *subjects = [NSMutableArray array];
                Item *item = [currentRoom.items objectForKey:key];
                NSString *itemName = @"@item(";
                itemName = [itemName stringByAppendingString:item.name];
                itemName = [itemName stringByAppendingString:@");"];
                if ([command respondsToVerb:self.verb subject:itemName]) {
                    [subjects addObjectsFromArray:item.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
            }
            
            for(id key in self.currentPlayer.items) {
                NSMutableArray *subjects = [NSMutableArray array];
                Item *item = [self.currentPlayer.items objectForKey:key];
                NSString *itemName = @"@inv(";
                itemName = [itemName stringByAppendingString:item.name];
                itemName = [itemName stringByAppendingString:@");"];
                if ([command respondsToVerb:self.verb subject:itemName]) {
                    [subjects addObjectsFromArray:item.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
            }
            
            for(id key in currentRoom.exits) {
                NSMutableArray *subjects = [NSMutableArray array];
                Exit *exit = [currentRoom.exits objectForKey:key];
                NSString *exitName = @"@exit(";
                exitName = [exitName stringByAppendingString:exit.name];
                exitName = [exitName stringByAppendingString:@");"];
                if ([command respondsToVerb:self.verb subject:exitName]) {
                    [subjects addObjectsFromArray:exit.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
            }
            
            for(id bley in currentRoom.containers) {
                Container *container = [currentRoom.containers objectForKey:bley];
                NSString *containerName = @"@container(";
                containerName = [containerName stringByAppendingString:container.name];
                containerName = [containerName stringByAppendingString:@");"];
                if ([command respondsToVerb:self.verb subject:containerName]) {
                    NSMutableArray *subjects = [NSMutableArray array];
                    [subjects addObjectsFromArray:container.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
                
                if (!container.locked){
                    for(id key in container.items) {
                        NSMutableArray *subjects = [NSMutableArray array];
                        Item *item = [container.items objectForKey:key];
                        NSString *itemName = @"@item(";
                        itemName = [itemName stringByAppendingString:item.name];
                        itemName = [itemName stringByAppendingString:@");"];
                        if ([command respondsToVerb:self.verb subject:itemName]) {
                            [subjects addObjectsFromArray:item.keywords];
                            Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                            [tempCommands addObject:newCommand];
                        }
                    }
                }
            }
            
            for(int i = 0; i < currentRoom.mobs.count; i++) {
                NSMutableArray *subjects = [NSMutableArray array];
                Mob *mob = [currentRoom.mobs objectAtIndex:i];
                NSString *mobName = @"@mob(";
                mobName = [mobName stringByAppendingString:mob.name];
                mobName = [mobName stringByAppendingString:@");"];
                if ([command respondsToVerb:self.verb subject:mobName]) {
                    [subjects addObjectsFromArray:mob.keywords];
                    Command *newCommand = [[Command alloc] initWithCommand:command andSubjects:subjects];
                    [tempCommands addObject:newCommand];
                }
            }
        }
    }
    
    return tempCommands;
}

- (NSString*)RunCommands:(NSArray*)commands dynamicCommands:(NSArray*)dynamicCommands {
    NSMutableArray *tempCommands = [NSMutableArray array];
    
    // First, generate any dynamic commands
    tempCommands = [self GenerateDynamicCommands:dynamicCommands tempCommands:tempCommands];
    
    // Next, look to see if one of our new dynamic room commands fulfils the role
    if (tempCommands != nil) {
        for (int i = 0; i < tempCommands.count; i++) {
            Command *command = [tempCommands objectAtIndex:i];
            if ([command respondsToVerb:self.verb subject:self.subject]) {
                return [self JustinTimeInterpret:[self CheckConditions:[command result]]];
            }
        }
    }
    
    // Then, look to see if we can otherwise handle this shiz
    for (int i = 0; i < commands.count; i++) {
        Command *command = [commands objectAtIndex:i];
        if ([command respondsToVerb:self.verb subject:self.subject]) {
            return [self JustinTimeInterpret:[self CheckConditions:[command result]]];
        }
    }
    
    // Last, look to see if we have a wildcard command
    for (int i = 0; i < commands.count; i++) {
        Command *command = [commands objectAtIndex:i];
        if ([command respondsToVerb:@"wildcard" subject:self.subject]) {
            return [self JustinTimeInterpret:[self CheckConditions:[command result]]];
        }
    }
    
    return nil;
}

- (NSString*)CheckConditions:(NSDictionary*)result {
    Room *currentRoom = [self.rooms objectForKey:self.currentPlayer.currentRoomName];
    
    for(id screy in result) {
        NSString *output = [result objectForKey:screy];
        for(id key in currentRoom.items) {
            Item *item = [currentRoom.items objectForKey:key];
            NSString *itemName = @"@item(";
            itemName = [itemName stringByAppendingString:item.name];
            itemName = [itemName stringByAppendingString:@");"];
            if ([screy isEqualToString:itemName]) {
                return output;
            }
        }
        
        for(id key in self.currentPlayer.items) {
            Item *item = [self.currentPlayer.items objectForKey:key];
            NSString *itemName = @"@inv(";
            itemName = [itemName stringByAppendingString:item.name];
            itemName = [itemName stringByAppendingString:@");"];
            if ([screy isEqualToString:itemName]) {
                return output;
            }
        }
        
        for(id key in currentRoom.exits) {
            Exit *exit = [currentRoom.exits objectForKey:key];
            NSString *exitName = @"@exit(";
            exitName = [exitName stringByAppendingString:exit.name];
            exitName = [exitName stringByAppendingString:@");"];
            if ([screy isEqualToString:exitName]) {
                return output;
            }
        }
        
        for(id bley in currentRoom.containers) {
            Container *container = [currentRoom.containers objectForKey:bley];
            NSString *containerName = @"@container(";
            containerName = [containerName stringByAppendingString:container.name];
            containerName = [containerName stringByAppendingString:@");"];
            if ([screy isEqualToString:containerName]) {
                return output;
            }
            
            if (!container.locked){
                for(id key in container.items) {
                    Item *item = [container.items objectForKey:key];
                    NSString *itemName = @"@item(";
                    itemName = [itemName stringByAppendingString:item.name];
                    itemName = [itemName stringByAppendingString:@");"];
                    if ([screy isEqualToString:itemName]) {
                        return output;
                    }
                }
            }
        }
        
        for(id key in self.variables) {
            NSUInteger varLocation = [screy rangeOfString:@"@var("].location;
            if (varLocation != NSNotFound) {
                NSUInteger endLocation = [screy rangeOfString:@");"].location;
                NSString *args = [screy substringWithRange:NSMakeRange(varLocation + 5, endLocation - varLocation - 5)];
                args = [args stringByReplacingOccurrencesOfString:@", " withString:@","];
                NSArray *argsList = [args componentsSeparatedByString:@","];
                if (argsList.count == 3)
                {
                    JVVariableType type = JVVariableTypeBool;
                    if ([[argsList objectAtIndex:0] caseInsensitiveCompare:@"int"] == NSOrderedSame) type = JVVariableTypeInt;
                    if ([[argsList objectAtIndex:0] caseInsensitiveCompare:@"string"] == NSOrderedSame) type = JVVariableTypeString;
                    if ([[argsList objectAtIndex:0] caseInsensitiveCompare:@"double"] == NSOrderedSame) type = JVVariableTypeDouble;
                    if ([[argsList objectAtIndex:0] caseInsensitiveCompare:@"float"] == NSOrderedSame) type = JVVariableTypeFloat;
                    NSString *varName = [argsList objectAtIndex:1];
                    NSString *varValue = [argsList objectAtIndex:2];
                    
                    if ([varName isEqualToString:key]) {
                        if (type == JVVariableTypeBool) {
                            BOOL var = [[self.variables objectForKey:key] boolValue];
                            if ([varValue caseInsensitiveCompare:@"true"] == NSOrderedSame) if (var == true) return output;
                            if ([varValue caseInsensitiveCompare:@"false"] == NSOrderedSame) if (var == false) return output;
                        }
                        if (type == JVVariableTypeString) {
                            NSString *var = [self.variables objectForKey:key];
                            if ([varValue isEqualToString:var]) return output;
                        }
                        if (type == JVVariableTypeInt) {
                            int var = [[self.variables objectForKey:key] intValue];
                            if ([varValue intValue] == var) return output;
                        }
                        if (type == JVVariableTypeFloat) {
                            float var = [[self.variables objectForKey:key] floatValue];
                            if ([varValue floatValue] == var) return output;
                        }
                        if (type == JVVariableTypeDouble) {
                            double var = [[self.variables objectForKey:key] doubleValue];
                            if ([varValue doubleValue] == var) return output;
                        }
                    }
                }
            }
        }
        
        for(int i = 0; i < currentRoom.mobs.count; i++) {
            Mob *mob = [currentRoom.mobs objectAtIndex:i];
            NSString *mobName = @"@mob(";
            mobName = [mobName stringByAppendingString:mob.name];
            mobName = [mobName stringByAppendingString:@");"];
            if ([screy isEqualToString:mobName]) {
                return output;
            }
        }
    }
    return [result objectForKey:@"Else"];
}

- (NSString*)JustinTimeInterpret:(NSString*)input {
    NSString *output = [input copy];
    
    NSUInteger runLocation = [output rangeOfString:@"@run("].location;
    if (runLocation != NSNotFound) {
        NSUInteger endLocation = [[output substringFromIndex:runLocation] rangeOfString:@");"].location + runLocation;
        return [self runUserInput:[output substringWithRange:NSMakeRange(runLocation + 5, endLocation - runLocation - 5)]];
    }
    
    // HACK: just look for go, prompt, verb, and subject for now!
    output = [output stringByReplacingOccurrencesOfString:@"@verb;" withString:self.verb];
    output = [output stringByReplacingOccurrencesOfString:@"@subject;" withString:self.subject];
    
    NSUInteger failLocation = [output rangeOfString:@"@failed;"].location;
    if (failLocation != NSNotFound) {
        [_delegate failed];
        output = [output stringByReplacingOccurrencesOfString:@"@failed;" withString:@""];
    }
    
    NSUInteger cancelLocation = [output rangeOfString:@"@cancelDeath;"].location;
    if (cancelLocation != NSNotFound) {
        [_delegate cancelDeath];
        output = [output stringByReplacingOccurrencesOfString:@"@cancelDeath;" withString:@""];
    }
    
    Room *currentRoom = [self.rooms objectForKey:self.currentPlayer.currentRoomName];
    NSString *look = @"";
    NSString *returnInv = @"";
    NSString *commaInv = @"";
    
    for(id key in self.currentPlayer.items) {
        Item *item = [self.currentPlayer.items objectForKey:key];
        commaInv = returnInv = [returnInv stringByAppendingString:[item shortDescription]];
        returnInv = [returnInv stringByAppendingString:@"\n"];
        commaInv = [commaInv stringByAppendingString:@", "];
    }
    
    for(id key in currentRoom.items) {
        Item *item = [currentRoom.items objectForKey:key];
        if ([item respondsToKeyword:self.subject]) {
            look = [item lookDescription];
        }
    }
    
    for (int i = 0; i < currentRoom.mobs.count; i++) {
        Mob *mob = [currentRoom.mobs objectAtIndex:i];
        if ([mob respondsToKeyword:self.subject]) {
            int quantity = 0;
            for (int j = 0; j < currentRoom.mobs.count; j++) {
                Mob *quantMob = [currentRoom.mobs objectAtIndex:j];
                if ([mob.name isEqualToString:quantMob.name]) quantity++;
            }
            look = [mob lookDescription:quantity];
        }
    }
    
    for(id key in currentRoom.exits) {
        Exit *exit = [currentRoom.exits objectForKey:key];
        if ([exit respondsToKeyword:self.subject]) {
            look = [exit lookDescription];
        }
    }
    
    for(id key in currentRoom.containers) {
        Container *container = [currentRoom.containers objectForKey:key];
        if ([container respondsToKeyword:self.subject]) {
            look = [container lookDescription];
        }
    }
    output = [output stringByReplacingOccurrencesOfString:@"@look;" withString:look];
    output = [output stringByReplacingOccurrencesOfString:@"@inv(linebreak);" withString:returnInv];
    output = [output stringByReplacingOccurrencesOfString:@"@inv(comma);" withString:commaInv];
    
    
    NSUInteger getLocation = [output rangeOfString:@"@get("].location;
    if (getLocation != NSNotFound) {
        NSUInteger endLocation = [[output substringFromIndex:getLocation] rangeOfString:@");"].location + getLocation;
        NSString *itemName = [output substringWithRange:NSMakeRange(getLocation + 5, endLocation - getLocation - 5)];
        
        Item *item = [currentRoom.items objectForKey:itemName];
        if ([self.currentPlayer.items objectForKey:itemName] != nil) {
            Item *newItem = [self.currentPlayer.items objectForKey:itemName];
            [newItem setQuantity:newItem.quantity + 1];
        }
        else {
            Item *newItem = [[Item alloc] initWithItem:item];
            [newItem setQuantity:1];
            NSMutableDictionary *dictionary = self.currentPlayer.items;
            [dictionary setObject:newItem forKey:itemName];
            [self.currentPlayer setItems:dictionary];
        }
        //item.quantity = [[currentRoom.items objectForKey:itemName] quantity] - 1;
        //if (item.quantity == 0) [currentRoom.items removeObjectForKey:itemName];
        
        output = item.getText;
    }
    
    NSUInteger promptLocation = [output rangeOfString:@"@prompt("].location;
    if (promptLocation != NSNotFound) {
        NSUInteger endLocation = [[output substringFromIndex:promptLocation] rangeOfString:@");"].location + promptLocation;
        self.promptText = [output substringWithRange:NSMakeRange(promptLocation + 8, endLocation - promptLocation - 8)];
        
        NSString *promptCommand = @"";
        if (output.length > endLocation + 2 && [output characterAtIndex:endLocation + 2] == '\n') {
            promptCommand = [output substringWithRange:NSMakeRange(promptLocation, endLocation - promptLocation + 3)];
        }
        else {
            promptCommand = [output substringWithRange:NSMakeRange(promptLocation, endLocation - promptLocation + 2)];
        }
        NSString *processedOutput = [output stringByReplacingOccurrencesOfString:promptCommand withString:@""];
        
        output = processedOutput;
    }
    
    NSUInteger setLocation = [output rangeOfString:@"@set("].location;
    if (setLocation != NSNotFound) {
        NSUInteger endLocation = [[output substringFromIndex:setLocation] rangeOfString:@");"].location;
        NSString *args = [output substringWithRange:NSMakeRange(setLocation + 5, endLocation - setLocation - 5)];
        args = [args stringByReplacingOccurrencesOfString:@", " withString:@","];
        NSArray *argsList = [args componentsSeparatedByString:@","];
        if (argsList.count == 3)
        {
            JVVariableType type = JVVariableTypeBool;
            if ([[argsList objectAtIndex:0] caseInsensitiveCompare:@"int"] == NSOrderedSame) type = JVVariableTypeInt;
            if ([[argsList objectAtIndex:0] caseInsensitiveCompare:@"string"] == NSOrderedSame) type = JVVariableTypeString;
            if ([[argsList objectAtIndex:0] caseInsensitiveCompare:@"double"] == NSOrderedSame) type = JVVariableTypeDouble;
            if ([[argsList objectAtIndex:0] caseInsensitiveCompare:@"float"] == NSOrderedSame) type = JVVariableTypeFloat;
            NSString *varName = [argsList objectAtIndex:1];
            NSString *varValue = [argsList objectAtIndex:2];
            
            if (type == JVVariableTypeBool) {
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterNoStyle];
                NSNumber *falseNum = [f numberFromString:@"0"];
                NSNumber *trueNum = [f numberFromString:@"1"];
                if ([varValue caseInsensitiveCompare:@"true"] == NSOrderedSame) [self.variables setObject:trueNum forKey:varName];
                if ([varValue caseInsensitiveCompare:@"false"] == NSOrderedSame) [self.variables setObject:falseNum forKey:varName];
            }
            if (type == JVVariableTypeString) {
                NSString *var = varValue;
                [self.variables setObject:var forKey:varName];
            }
            if (type == JVVariableTypeInt || type == JVVariableTypeFloat || type == JVVariableTypeDouble) {
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber *var = [f numberFromString:varValue];
                [self.variables setObject:var forKey:varName];
            }
        }
        
        
        NSString *setCommand = @"";
        if (output.length > endLocation + 2 && [output characterAtIndex:endLocation + 2] == '\n') {
            setCommand = [output substringWithRange:NSMakeRange(setLocation, endLocation - setLocation + 3)];
        }
        else {
            setCommand = [output substringWithRange:NSMakeRange(setLocation, endLocation - setLocation + 2)];
        }
        output = [output stringByReplacingOccurrencesOfString:setCommand withString:@""];
    }
    
    NSUInteger addLocation = [output rangeOfString:@"@add("].location;
    if (addLocation != NSNotFound) {
        NSUInteger endLocation = [[output substringFromIndex:addLocation] rangeOfString:@");"].location + addLocation;
        NSString *args = [output substringWithRange:NSMakeRange(addLocation + 5, endLocation - addLocation - 5)];
        args = [args stringByReplacingOccurrencesOfString:@", " withString:@","];
        NSArray *argsList = [args componentsSeparatedByString:@","];
        int quantity = 1;
        
        if (argsList.count > 1) {
            NSString *name = [argsList objectAtIndex:0];
            if (argsList.count == 3) quantity = [[argsList objectAtIndex:2] intValue];
            if ([[argsList objectAtIndex:1] caseInsensitiveCompare:@"item"] == NSOrderedSame) {
                Item *item = [[Item alloc] initWithItem:[self.items objectForKey:name]];
                if ([currentRoom.items objectForKey:name] != nil) {
                    Item *newItem = [currentRoom.items objectForKey:name];
                    [newItem setQuantity:newItem.quantity + quantity];
                }
                else {
                    Item *newItem = [[Item alloc] initWithItem:item];
                    [newItem setQuantity:quantity];
                    [currentRoom.items setObject:newItem forKey:name];
                }
            }
            if ([[argsList objectAtIndex:1] caseInsensitiveCompare:@"mob"] == NSOrderedSame) {
                Mob *mob = [self.mobs objectForKey:name];
                for (int i = 0; i < quantity; i++) {
                    Mob *newMob = [[Mob alloc] initWithMob:mob];
                    [currentRoom.mobs addObject:newMob];
                }
            }
        }
        
        NSString *addCommand = @"";
        if (output.length > endLocation + 2 && [output characterAtIndex:endLocation + 2] == '\n') {
            addCommand = [output substringWithRange:NSMakeRange(addLocation, endLocation - addLocation + 3)];
        }
        else {
            addCommand = [output substringWithRange:NSMakeRange(addLocation, endLocation - addLocation + 2)];
        }
        output = [output stringByReplacingOccurrencesOfString:addCommand withString:@""];
    }
    
    NSUInteger removeLocation = [output rangeOfString:@"@remove("].location;
    if (removeLocation != NSNotFound) {
        NSUInteger endLocation = [[output substringFromIndex:removeLocation] rangeOfString:@");"].location + removeLocation;
        NSString *args = [output substringWithRange:NSMakeRange(removeLocation + 8, endLocation - removeLocation - 8)];
        args = [args stringByReplacingOccurrencesOfString:@", " withString:@","];
        NSArray *argsList = [args componentsSeparatedByString:@","];
        int quantity = 1;
        
        if (argsList.count > 1) {
            NSString *name = [argsList objectAtIndex:0];
            if (argsList.count == 3) quantity = [[argsList objectAtIndex:2] intValue];
            if ([[argsList objectAtIndex:1] caseInsensitiveCompare:@"item"] == NSOrderedSame) {
                Item *item = [currentRoom.items objectForKey:name];
                item.quantity = [[currentRoom.items objectForKey:name] quantity] - quantity;
                if (item.quantity < 1) [currentRoom.items removeObjectForKey:name];
            }
            if ([[argsList objectAtIndex:1] caseInsensitiveCompare:@"mob"] == NSOrderedSame) {
                for (int i = 0; i < quantity; i++) {
                    if ([[[currentRoom.mobs objectAtIndex:i] name] caseInsensitiveCompare:name] == NSOrderedSame) {
                        [currentRoom.mobs removeObjectAtIndex:i];
                    }
                }
            }
        }
        
        NSString *removeCommand = @"";
        if (output.length > endLocation + 2 && [output characterAtIndex:endLocation + 2] == '\n') {
            removeCommand = [output substringWithRange:NSMakeRange(removeLocation, endLocation - removeLocation + 3)];
        }
        else {
            removeCommand = [output substringWithRange:NSMakeRange(removeLocation, endLocation - removeLocation + 2)];
        }
        output = [output stringByReplacingOccurrencesOfString:removeCommand withString:@""];
    }
    
    NSUInteger goLocation = [output rangeOfString:@"@go("].location;
    if (goLocation != NSNotFound) {
        NSUInteger endLocation = [output rangeOfString:@");"].location;
        NSString *args = [output substringWithRange:NSMakeRange(goLocation + 4, endLocation - goLocation - 4)];
        NSArray *argsList = [args componentsSeparatedByString:@","];
        JVIntroType type = JVIntroTypeReplace;
        if (argsList.count > 0) {
            self.currentPlayer.currentRoomName = [argsList objectAtIndex:0];
        }
        if (argsList.count > 1) {
            NSString *typeStr = [argsList objectAtIndex:1];
            typeStr = [typeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([typeStr isEqualToString:@"append"]) {
                type = JVIntroTypeAppend;
            }
            else if ([typeStr isEqualToString:@"replace"]) {
                type = JVIntroTypeReplace;
            }
            else if ([typeStr isEqualToString:@"ignore"]) {
                type = JVIntroTypeIgnore;
            }
        }
        
        NSString *arriveText = @"";
        // Find the arrive command for this room
        NSArray *commands = [[self.rooms objectForKey:self.currentPlayer.currentRoomName] commands];
        for (int i = 0; i < commands.count; i++) {
            Command *command = [commands objectAtIndex:i];
            if ([command respondsToInternalName:@"arrive"]) {
                arriveText = [self CheckConditions:[command result]];
            }
        }
        
        // Do the right thing based on mode
        NSString *goCommand = @"";
        if (output.length > endLocation + 2 && [output characterAtIndex:endLocation + 2] == '\n') {
            goCommand = [output substringWithRange:NSMakeRange(goLocation, endLocation - goLocation + 3)];
        }
        else {
            goCommand = [output substringWithRange:NSMakeRange(goLocation, endLocation - goLocation + 2)];
        }
        NSString *processedOutput = [output stringByReplacingOccurrencesOfString:goCommand withString:@""];
        if (type == JVIntroTypeIgnore) {
            return processedOutput;
        }
        else if (type == JVIntroTypeAppend) {
            return [processedOutput stringByAppendingString:[self JustinTimeInterpret:arriveText]];
        }
        else {
            return [self JustinTimeInterpret:arriveText];
        }
    }
    
    return output;
}


@end
