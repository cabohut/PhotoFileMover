//
//  AppDelegate.swift
//  PhotoFileMover
//
//  Created by sam on 8/2/17.
//  Copyright © 2017 Cabohut. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    @objc func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    @objc func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func menuHelp(_ sender: Any) {
        print ("In menu")
    }

}

