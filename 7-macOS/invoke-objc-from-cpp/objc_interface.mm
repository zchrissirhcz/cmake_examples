#include <Cocoa/Cocoa.h>
#include "objc_interface.h"

// Implement the function declared in the header  
void showObjectiveCWindow() {
    @autoreleasepool {
            // Create an application instance
            [NSApplication sharedApplication];

            // Create a window
            NSRect frame = NSMakeRect(100, 100, 400, 300);
            NSWindow* window = [[NSWindow alloc] initWithContentRect:frame
            styleMask:(NSWindowStyleMaskTitled |
            NSWindowStyleMaskClosable |
            NSWindowStyleMaskResizable)
            backing:NSBackingStoreBuffered
            defer:NO];

            // Set the window title
            [window setTitle:@"Objective-C++ Window"];

            // Make the window visible
            [window makeKeyAndOrderFront:nil];

            // Run the application
            [NSApp run];
    }
}