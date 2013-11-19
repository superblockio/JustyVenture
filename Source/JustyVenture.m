//
//  JustyVenture.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "JustyVenture.h"
#import "Command.h"

typedef enum {
    JVXMLRoomContext,
    JVXMLCommandsContext,
    JVXMLOuterContext
}JVXMLContext;

typedef enum {
    JVIntroTypeReplace,
    JVIntroTypeAppend,
    JVIntroTypeIgnore
}JVIntroType;

@interface JustyVenture () {
}

@property(nonatomic, assign) JVIntroType introType;
@property(nonatomic, strong) NSXMLParser *parser;
@property(nonatomic, strong) NSString *currentElementBody;
@property(nonatomic, strong) NSMutableArray *currentTags;
@property(nonatomic, strong) Room *currentRoomXML;
@property(nonatomic, strong) Command *currentCommandXML;

@property (nonatomic, strong) NSMutableDictionary *rooms;
@property (nonatomic, strong) NSMutableDictionary *variables;
@property (nonatomic, strong) NSMutableDictionary *items;
@property (nonatomic, strong) NSMutableArray *commands;
    
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *verb;
@property (nonatomic, assign) BOOL firstTag;

@end

@implementation JustyVenture

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
        self.commands = [[NSMutableArray alloc] init];
        self.adventureTitle = @"Adventure!";
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
    self.promptText = @"What wouldst thou deau?";
    self.verb = [[input componentsSeparatedByString:@" "] objectAtIndex:0];
    self.subject = @"";
    if ([[input componentsSeparatedByString:@" "] count] > 1) {
        self.subject = [input substringFromIndex:self.verb.length + 1];
    }
    // First, look to see if the room can handle this shiz
    Room *currentRoom = [self.rooms objectForKey:self.currentRoomName];
    for (int i = 0; i < [currentRoom commands].count; i++) {
        Command *command = [[currentRoom commands] objectAtIndex:i];
        if ([command respondsToVerb:self.verb subject:self.subject]) {
            return [self JustinTimeInterpret:[command result]];
        }
    }
    
    // Next, see if one of our fallback commands can handle it.
    for (int i = 0; i <self.commands.count; i++) {
        Command *command = [self.commands objectAtIndex:i];
        if ([command respondsToVerb:self.verb subject:self.subject]) {
            return [self JustinTimeInterpret:[command result]];
        }
    }
    
    if (![self.subject isEqual: @""])return [NSString stringWithFormat:@"You attempt to %@ the %@ but it-What's wrong with you!?  Why would even try such a thing?!  You need some serious HELP man.", self.verb, self.subject];
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
                [self setCurrentRoomName:[attributeDict objectForKey:@"firstRoom"]];
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
        Command *command = [[Command alloc] init];
        
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
        [self.currentCommandXML setResult:self.currentElementBody];
        [self.currentRoomXML setCommands:[self.currentRoomXML.commands arrayByAddingObject:self.currentCommandXML]];
    }
    
    else if ([self context] == JVXMLCommandsContext) {
        [self.currentCommandXML setResult:self.currentElementBody];
        [self.commands addObject:self.currentCommandXML];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // We have to do the intro text here because the room might not be loaded when the intro tag is first read
    Room *firstRoom = [self.rooms objectForKey:self.currentRoomName];
    if (self.introType != JVIntroTypeReplace) {
        for (int i = 0; i < firstRoom.commands.count; i++) {
            if ([[firstRoom.commands objectAtIndex:i] respondsToInternalName:@"arrive"]) {
                NSString *arrive = [[firstRoom.commands objectAtIndex:i] result];
                if (self.introType == JVIntroTypeAppend) {
                    self.introText = [self.introText stringByAppendingString:arrive];
                }
                else {
                    self.introText = arrive;
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
    return JVXMLOuterContext;
}

- (NSString*)JustinTimeInterpret:(NSString*)input {
    NSString *output = [input copy];
    
    // HACK: just look for go, prompt, verb, and subject for now!
    output = [output stringByReplacingOccurrencesOfString:@"@verb;" withString:self.verb];
    output = [output stringByReplacingOccurrencesOfString:@"@subject;" withString:self.subject];
    
    NSUInteger promptLocation = [output rangeOfString:@"@prompt("].location;
    if (promptLocation != NSNotFound) {
        NSUInteger endLocation = [[output substringFromIndex:promptLocation] rangeOfString:@");"].location + promptLocation;
        self.promptText = [output substringWithRange:NSMakeRange(promptLocation + 8, endLocation - promptLocation - 8)];
        
        // Do the right thing based on mode
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

    NSUInteger goLocation = [output rangeOfString:@"@go("].location;
    if (goLocation != NSNotFound) {
        NSUInteger endLocation = [output rangeOfString:@");"].location;
        NSString *args = [output substringWithRange:NSMakeRange(goLocation + 4, endLocation - goLocation - 4)];
        NSArray *argsList = [args componentsSeparatedByString:@","];
        JVIntroType type = JVIntroTypeReplace;
        if (argsList.count > 0) {
            self.currentRoomName = [argsList objectAtIndex:0];
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
        NSArray *commands = [[self.rooms objectForKey:self.currentRoomName] commands];
        for (int i = 0; i < commands.count; i++) {
            Command *command = [commands objectAtIndex:i];
            if ([command respondsToInternalName:@"arrive"]) {
                arriveText = [command result];
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
            return [processedOutput stringByAppendingString:arriveText];
        }
        else {
            return arriveText;
        }
    }
    
    return output;
}


@end
