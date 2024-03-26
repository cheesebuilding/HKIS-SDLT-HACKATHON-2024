//
//  PostHistoryView.swift
//  HKIS-SDLT-HACKATHON-2024
//
//  Created by Micah Chen on 3/16/24.
//

import SwiftUI

struct ClaimedItemView: View {
    var post: Post
    var claimedByMe: Bool

    var body: some View {
        VStack {
            Text(post.itemName)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("Found at: \(post.foundLocation)")
                .multilineTextAlignment(.center)
            Text("Drop off at: \(post.dropOffLocation)")
                .multilineTextAlignment(.center)
            Text(claimedByMe ? "Claimed by you" : "Claimed by \(post.claimedBy ?? "")")
                .multilineTextAlignment(.center)
            post.selectedImage?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
        }
        .padding()
    }
}
struct PostHistoryView: View {
    @EnvironmentObject var postData: PostData
    @State var username: String

    var body: some View {
        List {
            Section(header: Text("Items Claimed By Me")) {
                ForEach(postData.posts.filter { $0.claimed && $0.claimedBy == username }, id: \.id) { post in
                    ClaimedItemView(post: post, claimedByMe: true)
                }
            }

            Section(header: Text("My Items Claimed By Others")) {
                ForEach(postData.posts.filter { $0.claimed && $0.username == username }, id: \.id) { post in
                    ClaimedItemView(post: post, claimedByMe: false)
                }
            }
        }
        .navigationTitle("Claimed Items")
    }
}
