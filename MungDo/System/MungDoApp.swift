//
//  MungDoApp.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseFirestore
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Colors application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        FirebaseApp.configure()
        //taskDelay test
        TaskDelayService.delayOverDueTask()
        return true
    }
}



@main
struct MungDoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FontManager.registerCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
     .modelContainer(for: [
                    TaskItemEntity.self,
                    TaskScheduleEntity.self,
                    TaskRecurrenceEntity.self,
                    SimpleTaskEntity.self
                ])
        }
    }
}
