## INAppStoreWindow: Mac App Store style NSWindow subclass

INAppStoreWindow is an NSWindow subclass that mimics the appearance of the main window in the Mac App Store application. These modifications consist of enlarging the title bar, and centring the traffic lights (**note that this subclass does not handle the creation of a toolbar**). The end result looks like this:

![INAppStoreWindow](http://i41.tinypic.com/abidd1.png)

**Features of INAppStoreWindow:**

* No use of private APIs, so it should be App Store friendly
* The title bar view is entirely customizable -- you can add subviews (toolbars, buttons, etc.) as well as customize the title bar itself to give it a different appearance
* The height of the title bar is easily adjustable
* Compiles and runs perfectly under ARC and non-ARC setups (thanks to @InScopeApps)
* Support's Lion's full screen mode

## Usage

### Basic Configuration

Using `INAppStoreWindow` is as easy as changing the class of the `NSWindow` in Interface Builder, or simply by creating an instance of `INAppStoreWindow` in code (if you're doing it programatically). I've included a sample project demonstrating how to use `INAppStoreWindow`.

**NOTE: The title bar height is set to the standard window title height by default. You must set the 'titleBarHeight' property in order to increase the height of the title bar.**

Some people seem to be having an issue where the title bar height property is not set properly when calling the method on an NSWindow without typecasting it to the INAppStoreWindow class. If you are experiencing this issue, do something like this (using a window controller, for example):

    INAppStoreWindow *aWindow = (INAppStoreWindow*)[windowController window];
    aWindow.titleBarHeight = 60.0;

### Sheet Windows

Because of the enlarged title bar, sheet windows may not appear properly (it'll look like they're popping out of the center of the title bar). To fix this, override this `NSWindow` delegate method and return an appropriate rect for where you want the sheet window to be positioned:

`- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect`

### Adding buttons and other controls to the title bar

Adding controls and other views to the title bar is simple. This can be done either programatically or through Interface Builder. Here are examples of both methods:

**Programatically**

```
// This code places a 100x100 button in the center of the title bar view
NSView *titleBarView = self.window.titleBarView;
NSSize buttonSize = NSMakeSize(100.f, 100.f);
NSRect buttonFrame = NSMakeRect(NSMidX(titleBarView.bounds) - (buttonSize.width / 2.f), NSMidY(titleBarView.bounds) - (buttonSize.height / 2.f), buttonSize.width, buttonSize.height);
NSButton *button = [[NSButton alloc] initWithFrame:buttonFrame];
[button setTitle:@"A Button"];
[titleBarView addSubview:button];
````

**Interface Builder**

**NOTE:** Even though the content layout for the title bar can be done in Interface Builder, you still need to use the below code to display the view created in IB in the title bar.

```
// self.titleView is a an IBOutlet to an NSView that has been configured in IB with everything you want in the title bar
self.titleView.frame = self.window.titleBarView.bounds;
self.titleView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
[self.window.titleBarView addSubview:self.titleView];
```

## Who am I?

I'm Indragie Karunaratne, a 16 year old Mac OS X and iOS Developer from Edmonton AB, Canada. Visit [my website](http://indragie.com) to check out my work, or to get in touch with me.

## Special Thanks To

- Alex Rozanski ([@Perspx](https://github.com/perspx))
- David Keegan ([@InScopeApps](https://github.com/inscopeapps))
- Victor Pimentel ([@victorpimentel](https://github.com/victorpimentel))
- Wade Cosgrove ([@wadeco](https://github.com/wadeco))
- Levi Nunnink ([@levinunnink](https://github.com/levinunnink))
- Georg C. Brückmann ([@gcbrueckmann](https://github.com/gcbrueckmann))
- nonamelive ([@nonamelive](https://github.com/nonamelive))

## Licensing

INAppStoreWindow is licensed under the [BSD license](http://www.opensource.org/licenses/bsd-license.php).