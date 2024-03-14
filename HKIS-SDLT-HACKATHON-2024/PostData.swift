//
//  PostData.swift
//  HKIS-SDLT-HACKATHON-2024
//
//  Created by Micah Chen on 3/10/24.
//
import Foundation
import Combine

class PostData: ObservableObject {
    @Published var posts: [Post] = [] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(posts) {
                UserDefaults.standard.set(encoded, forKey: "Posts")
            }
        }
    }

    init() {
        if let posts = UserDefaults.standard.data(forKey: "Posts") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Post].self, from: posts) {
                self.posts = decoded
            }
        }
    }
}
