import Cocoa
import SwiftUI
import WebKit


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        
        
        let contentView = ContentView()
        let popover = NSPopover()
        
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            if #available(macOS 11.0, *) {
                button.image = NSImage(systemSymbolName: "point.topleft.down.curvedto.point.bottomright.up", accessibilityDescription: nil)
            } else {
                // Todo: Fallback for earlier versions
            }
            button.action = #selector(toggle(_:))
        }
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func toggle(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
}



