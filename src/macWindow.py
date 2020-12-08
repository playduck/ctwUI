from ctypes import c_void_p
from functools import reduce

import Cocoa
import objc

# from PyQt5.QtWidgets import QMacCocoaViewContainer

# this one took a while to figure out
# credit for the proof of concept from here:
# https://stackoverflow.com/a/36247184/12231900
# fullscreen fix from:
# https://developer.apple.com/forums/thread/127382


def setCustomWindow(engine: object) -> None:
    # get the applications winId as sip.voidptr
    # this requires the QML ApplicationWindow to be the first child of root
    winId_p = engine.rootObjects()[0].winId()
    # since
    # int(winId) == int(view) -> True
    # we can skip creating a QMacCocoaViewContainer and getting it's cocoaView
    # apparently pyqt/qt doesn't do anything fancy behind the scenes
    # so the following is unnessacery; somebody could have told me sooner

    # ViewContainer = QMacCocoaViewContainer(winId)
    # viewPtr = c_void_p(int(ViewContainer.cocoaView()))

    # register a pyobjc NSView from the Qt ApplicationWindow pointer
    # obtained by its winId or cocoaView
    viewPtr = c_void_p(int(winId_p))
    nsview = objc.objc_object(c_void_p=viewPtr)

    # get NSView's NSWindow for styling
    nswin = nsview.window()

    # set frameless but enable buttons
    styleMasks = (
        # nswin.styleMask(),  # retain default flags
        Cocoa.NSWindowStyleMaskFullSizeContentView,
        Cocoa.NSWindowTitleHidden,
        Cocoa.NSWindowStyleMaskClosable,
        Cocoa.NSWindowStyleMaskMiniaturizable,
        Cocoa.NSWindowStyleMaskResizable,
        Cocoa.NSWindowStyleMaskFullSizeContentView
    )
    nswin.setStyleMask_(reduce(lambda a, b: a | b, styleMasks, 0))

    nswin.setTitlebarAppearsTransparent_(True)
    nswin.setMovableByWindowBackground_(False)

    # disable fullscreen mode, change it to zoom
    behaviors = (
        Cocoa.NSWindowCollectionBehaviorFullScreenAuxiliary,
        Cocoa.NSWindowCollectionBehaviorFullScreenNone,
        Cocoa.NSWindowCollectionBehaviorFullScreenDisallowsTiling
    )
    nswin.setCollectionBehavior_(reduce(lambda a, b: a | b, behaviors, 0))


def getColor() -> str:
    colorSpace = Cocoa.NSColorSpace.sRGBColorSpace()
    sysColor = Cocoa.NSColor.windowBackgroundColor()
    color = sysColor.colorUsingColorSpace_(colorSpace)

    r = g = b = a = None
    components = color.getRed_green_blue_alpha_(r, g, b, a)
    (r, g, b, a) = [int(x * 255) for x in components]
    code = "#{:02X}{:02X}{:02X}{:02X}".format(a, r, g, b)

    return code
