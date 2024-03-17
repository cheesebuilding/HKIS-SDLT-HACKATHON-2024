//
//  HKIS_SDLT_HACKATHON_2024App.swift
//  HKIS-SDLT-HACKATHON-2024
//
//  Created by Micah Chen on 3/3/24.
//

import SwiftUI
import CoreData

@main
struct HKIS_SDLT_HACKATHON_2024App: App {
    
    @StateObject private var postData = PostData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
