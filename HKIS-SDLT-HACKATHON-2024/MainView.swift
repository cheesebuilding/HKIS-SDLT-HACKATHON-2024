

import SwiftUI

class PostData: ObservableObject {
    @Published var posts: [Post] = [] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(posts) {
                let url = Self.dataFileURL
                do {
                    try encoded.write(to: url)
                } catch {
                    print("Error writing data to file: \(error)")
                }
            }
        }
    }
    
    init() {
        let url = Self.dataFileURL
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: url),
           let decoded = try? decoder.decode([Post].self, from: data) {
            self.posts = decoded
        }
    }
    
    private static var dataFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("Posts.data")
    }
}

struct MainView: View {
    @EnvironmentObject var postData: PostData
    @State var username: String
    @State private var showingCreatePostView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    ForEach(postData.posts.indices, id: \.self) { index in
                        BoxView(post: postData.posts[index])
                    }
                }
            }
            .navigationBarTitle("Welcome, \(username)", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                showingCreatePostView = true
            }) {
                Text("+")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
                .sheet(isPresented: $showingCreatePostView) {
                    CreatePostView(username: $username, posts: $postData.posts)
                }
            )
        }
    }
}

struct BoxView: View {
    let post: Post

    var body: some View {
        VStack {
            Text(post.itemName)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)

            Text("Posted by \(post.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)

            post.selectedImage?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipped()

            Text("Found at: \(post.foundLocation)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)

            Text("Drop off at: \(post.dropOffLocation)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)

            Button(action: {}) {
                Text("Claim")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10.0)
            }
            .padding(.bottom, 10)
        }
        .frame(width: 350)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
#Preview{
    MainView(username: "").environmentObject(PostData())
    
}
