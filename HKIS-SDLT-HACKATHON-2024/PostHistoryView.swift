//
//  PostHistoryView.swift
//  HKIS-SDLT-HACKATHON-2024
//
//  Created by Micah Chen on 3/16/24.
//

import SwiftUI


struct ClaimedItemView: View {
    @EnvironmentObject var postData: PostData
    var post: Post

    var body: some View {
        VStack {
            Text(post.itemName)
            Text("Found at: \(post.foundLocation)")
            Text("Drop off at: \(post.dropOffLocation)")
            Button(action: {
                postData.giveBackPost(id: post.id)
            }) {
                Text("Given Back")
            }
            Button(action: {
                postData.notGivenBackPost(id: post.id)
            }) {
                Text("Not Given Back")
            }
        }
    }
}
struct PostHistoryView: View {
    @EnvironmentObject var postData: PostData

    var body: some View {
        List {
            ForEach(postData.posts.filter { $0.claimed }, id: \.id) { post in
                            ClaimedItemView(post: post)
            }
        }
    }
}


#Preview {
    PostHistoryView()
}
