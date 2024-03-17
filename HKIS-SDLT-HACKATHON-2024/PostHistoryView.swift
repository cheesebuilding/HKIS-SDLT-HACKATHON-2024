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

    @State private var givenBack = false

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
            HStack {
                Button(action: {
                    givenBack = true
                    postData.giveBackPost(id: post.id)
                }) {
                    Text("Given Back")
                        .padding()
                        .background(givenBack ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    givenBack = false
                    postData.notGivenBackPost(id: post.id)
                }) {
                    Text("Not Given Back")
                        .padding()
                        .background(!givenBack ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
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

#Preview{
    PostHistoryView()
}
