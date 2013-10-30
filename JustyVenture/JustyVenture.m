//
//  JustyVenture.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "JustyVenture.h"

@interface JustyVenture () {
}

@property(nonatomic, strong) NSXMLParser *parser;
@property(nonatomic, strong) NSString *currentElementBody;

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
        [self parseAdventureFiles];
    }
    return self;
}

- (void)parseAdventureFiles {
    NSString *directory = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Adventure Files/"];
    NSArray *adventureFiles = [self recursivePathsForResourcesOfType:@"jv" inDirectory:directory];
    for (NSString *jvPath in adventureFiles) {
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:jvPath]];
        self.parser.delegate = self;
        [self.parser parse];
    }
}

- (NSString*)runUserInput:(NSString*)input {
    // TODO: actually destroy them and stea-- I mean, return the right thing
    return @"I will destroy you and steal your fiancé!";
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
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentElementBody = [self.currentElementBody stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName caseInsensitiveCompare:@"Intro"] == NSOrderedSame) {
        self.introText = self.currentElementBody;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XML parsing failed with error: %@", parseError);
}


@end
