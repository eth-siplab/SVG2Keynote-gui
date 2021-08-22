import SwiftUI
import Cocoa
import SVGWebView
import WebKit

var status: String = "Currently no status.";
var svgURL: String = "";


struct ContentView: View {
    @State var svgString: String =  """
                <svg xmlns="http://www.w3.org/2000/svg"
                     viewBox="0 0 100 100">
                  <rect x="10" y="10"
                        width="80" height="80"
                        fill="gold" stroke="blue"
                        stroke-width="4" />
                </svg>
                """
    @State var localStatus: String = status;
    var body: some View {
        VStack {
            SVGWebView(svg: svgString)
            Text(localStatus)
            Button("Open SVG File") {
                svgString = browseFile();
                localStatus = status;
            }
            Button("Convert SVG to Keynote Clipboard") {
                if (svgToClipboard(svgData: svgString)) {
                    updateStatus(newStatus: "SVG successfully converted to Keynote");
                    localStatus = status;
                }
                }
            }
        
        
        Button("Convert to PDF Clipboard") {
            setenv("PATH", "\("usr/local/bin"):\(ProcessInfo.processInfo.environment["PATH"]!)", 1)
            
            let fileName = "temp.pdf"
            let tempDir = NSTemporaryDirectory()
            let fileURL = URL(fileURLWithPath: tempDir, isDirectory: true).appendingPathComponent(fileName)
            
            
            let path = fileURL.path;
            let outpipe = Pipe()
            
            let inkscape = Process();
            inkscape.launchPath = "/usr/bin/env"
            inkscape.arguments = ["inkscape", svgURL, "-o", path];
            inkscape.standardOutput = outpipe
            
            inkscape.launch();
            inkscape.waitUntilExit();
            
            if (pdfToClipboard(pdfData: readFile(url: fileURL))) {
                updateStatus(newStatus: "SVG successfully converted to PDF");
                localStatus = status;
            } else {
                updateStatus(newStatus: "Failed to convert SVG to PDF");
                localStatus = status;

            }
        }
        Button("Decode and Encode") {
            decodeAndEncodeSwift();
        }
            Spacer()
        }
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func updateStatus(newStatus: String) -> Void {
    status = newStatus;
}

func readFile(url: URL) -> Data? {
    do {
        return try Data(contentsOf: url);
    }
        catch {
            NSLog("Error reading file");
        }
    
    return Data();
    
}

func browseFile() -> String {
    
    let dialog = NSOpenPanel();
    
    dialog.title                   = "Choose a .svg file";
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.canChooseDirectories    = false;
    dialog.canCreateDirectories    = true;
    dialog.allowsMultipleSelection = false;
    dialog.allowedFileTypes        = ["svg"];

    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
        let result = dialog.url // Pathname of the file
        
        if (result != nil) {

            let path = URL(fileURLWithPath: result!.path)
            NSLog(path.absoluteString);
            NSLog(path.path);
            svgURL = path.path;
            
            do {
                status = "SVG successfully loaded"
                return try String(contentsOf: path, encoding: .utf8);
            }
                catch {
                    NSLog("Error reading file");
                }
            

        }
    } else {
        // User clicked on "Cancel"
        status = "SVG loading failed!"
        return ""
    }
    return "";
}
