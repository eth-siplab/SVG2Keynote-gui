import Foundation
import Cocoa
import SwiftUI
import WebKit

func pdfToClipboard (pdfData:Data?) -> Bool {
    if (pdfData == nil) {
        return false
    }
    let pasteboard = NSPasteboard.general;
    let comAdobePdfType = NSPasteboard.PasteboardType(rawValue: "com.adobe.pdf");
    let applePDFPasteboardType = NSPasteboard.PasteboardType(rawValue: "Apple PDF pasteboard type");
    pasteboard.declareTypes([comAdobePdfType, applePDFPasteboardType], owner: nil);
    
    pasteboard.setData(pdfData, forType: NSPasteboard.PasteboardType("com.adobe.pdf"));
    pasteboard.setData(pdfData, forType: NSPasteboard.PasteboardType("Apple PDF pasteboard type"));
    
    return true;
}

func svgToClipboard (svgData: String) -> Bool {
    let clipboard = CPP_Wrapper().generateClipboard(forTSPNativeData: svgData);
    let metadata = CPP_Wrapper().generateClipboardMetadata();
    let pasteboard = NSPasteboard.general;
    
    // declare pasteboard types
    let TSPNativeDataType = NSPasteboard.PasteboardType(rawValue: "com.apple.iWork.TSPNativeData");
    let TSPNativeMetadataType = NSPasteboard.PasteboardType(rawValue: "com.apple.iWork.TSPNativeMetadata");
    let hasNativeDrawables = NSPasteboard.PasteboardType(rawValue: "com.apple.iWork.pasteboardState.hasNativeDrawables");
    
    pasteboard.declareTypes([TSPNativeDataType, TSPNativeMetadataType, hasNativeDrawables], owner: nil);
    pasteboard.setData(clipboard, forType: NSPasteboard.PasteboardType("com.apple.iWork.TSPNativeData"));
    pasteboard.setData(metadata, forType: NSPasteboard.PasteboardType("com.apple.iWork.TSPNativeMetadata"));
    pasteboard.setString("", forType: NSPasteboard.PasteboardType("com.apple.iWork.pasteboardState.hasNativeDrawables"));
    
    return true;
}

func decodeAndEncodeSwift () -> Void {
    
    let pasteboard = NSPasteboard.general;
    let data = pasteboard.data(forType: NSPasteboard.PasteboardType("com.apple.iWork.TSPNativeData"))
    CPP_Wrapper().decodeAndEncodeClip(data);
}
