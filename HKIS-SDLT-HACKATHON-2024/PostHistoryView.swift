//
//  PostHistoryView.swift
//  HKIS-SDLT-HACKATHON-2024
//
//  Created by Micah Chen on 3/16/24.
//

import SwiftUI

struct ClaimedItemView: View {
    var post: Post

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
            ForEach(postData.posts.filter { $0.claimed && $0.claimedBy == username }, id: \.id) { post in
                ClaimedItemView(post: post)
            }
        }
        .navigationTitle("Claimed Items")
    }
}

#Preview{
    PostHistoryView(username: "Test").environmentObject(PostData())
}
