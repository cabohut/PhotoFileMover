//
//  ViewController.swift
//  PhotoFileMover
//
//  Created by sam on 8/2/17.
//  Copyright © 2017 Cabohut. All rights reserved.
//
/*

 Based on using sortphotos.py:
 https://github.com/andrewning/sortphotos
 
 Script wasn’t flexible when renaming a file, it didn’t offer to include the actual file name in the new name so I added the filename (line 372).
 
 Requires python executable at /usr/bin/python
 
 Now I can use this script to do the following:
 - rename the photo filename
 - move the file to the target folder (year/month)
 
 */


import Cocoa

class ViewController: NSViewController {

    var PYTHON_PATH = "/usr/bin/python"
    
    var recursiveMode = ""
    var copyFiles = ""
    var testMode = ""
    var silentMode = ""
    var subfolderOption = [""]
    var renameOption = [""]
    
    func setSubfolderFormat (i: Int) {
        switch i {
        case 1:
            subfolderOption = ["--sort", "%Y/%m"]
        case 2:
            subfolderOption = ["--sort", "%Y/%m/%d"]
        default:
            subfolderOption = []
        }
    }
    
    func setRenameFormat (i: Int) {
        switch i {
        case 1:
            renameOption = ["--rename", "%Y-%m-%d"]
        case 2:
            renameOption = ["--rename", "%m-%d-%Y"]
        default:
            renameOption = []
        }
    }
    
    func setRecursiveOption () {
        switch recursvieButton.state {
        case NSControl.StateValue.on:
            recursiveMode = "-r"
        default:
            recursiveMode = ""
        }
    }
    
    func setCopyOption () {
        switch copyFilesButton.state {
        case NSControl.StateValue.on:
            copyFiles = "-c"
        default:
            copyFiles = ""
        }
    }
    
    func setTestOption () {
        switch testOnlyButton.state {
        case NSControl.StateValue.on:
            testMode = "-t"
        default:
            testMode = ""
        }
    }
    
    func setSilentOption () {
        switch silentButton.state {
        case NSControl.StateValue.on:
            silentMode = "-s"
        default:
            silentMode = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setRecursiveOption()
        setCopyOption()
        setTestOption()
        setSilentOption()
        setSubfolderFormat(i: 1)
        setRenameFormat(i: 1)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var sourceFolderName: NSPathControl!
    @IBOutlet weak var destFolderName: NSPathControl!
    @IBOutlet weak var subfolderFormat: NSComboBox!
    @IBOutlet weak var renameFormat: NSComboBox!
    
    @IBOutlet weak var cmdParameters: NSTextField!

    @IBOutlet weak var recursvieButton: NSButton!
    @IBOutlet weak var copyFilesButton: NSButton!
    @IBOutlet weak var moveFilesButton: NSButton!
    @IBOutlet weak var testOnlyButton: NSButton!
    @IBOutlet weak var silentButton: NSButton!

    @IBOutlet var resultsView: NSTextView!
    
    @IBAction func sourceFolderSelector(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Select Source Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseFiles          = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                sourceFolderName.stringValue = result!.path
            }
        } else {
            sourceFolderName.stringValue = ""
            return
        }
    }

    @IBAction func distFolderSelector(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Select Destination Folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseFiles          = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                destFolderName.stringValue = result!.path
            }
        } else {
            destFolderName.stringValue = ""
            return
        }
    }
    
    @IBAction func subfolderOption(_ sender: Any) {
        setSubfolderFormat(i: subfolderFormat.indexOfSelectedItem)
    }
    
    @IBAction func renameOption(_ sender: Any) {
        setRenameFormat(i: renameFormat.indexOfSelectedItem)
    }
    
    @IBAction func recursiveOption(_ sender: Any) {
        setRecursiveOption()
    }
    
    @IBAction func copyOption(_ sender: NSButton) {
        setCopyOption()
    }
    
    @IBAction func testOption(_ sender: Any) {
        setTestOption()
    }
    
    @IBAction func silentOption(_ sender: Any) {
        setSilentOption()
    }
    
    @IBAction func submitRequest(_ sender: Any) {
        let task = Process()
        
        /* get the path for sortphotos.py from app bundle */
        let url = Bundle.main.url(forResource: "sortphotos", withExtension: "py")
        if (url == nil) {
            fatalError("sortphotos.py is missing")
        }
        
        task.launchPath = PYTHON_PATH
        task.arguments = [url!.path,
                          sourceFolderName.stringValue,
                          destFolderName.stringValue]
        
        if subfolderOption.count  > 0 {
            task.arguments = task.arguments! + subfolderOption
        }
        
        if renameOption.count  > 0 {
            task.arguments = task.arguments! + renameOption
        }

        if cmdParameters.stringValue.count  > 0 {
            task.arguments = task.arguments! + [cmdParameters.stringValue]
        }
        
        if recursiveMode.count  > 0 {
            task.arguments = task.arguments! + [recursiveMode]
        }
        
        if copyFiles.count  > 0 {
            task.arguments = task.arguments! + [copyFiles]
        }
        
        if testMode.count  > 0 {
            task.arguments = task.arguments! + [testMode]
        }
        
        if silentMode.count  > 0 {
            task.arguments = task.arguments! + [silentMode]
        }
        
        let outPipe = Pipe()
        task.standardOutput = outPipe
        
        task.launch()
        let fileHandle = outPipe.fileHandleForReading
        let data = fileHandle.readDataToEndOfFile()
        
        task.waitUntilExit()
        let status = task.terminationStatus
        if status != 0 {
            print (task.arguments!)
            fatalError ("Error executing the command")
        } else {
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
            resultsView.string = string as String
        }
    }
}
