

import SwiftUI

enum ActiveSheet: Identifiable {
    case createPost, postHistory

    var id: Int {
        hashValue
    }
}

class PostData: ObservableObject {
    @Published var usernames: [String] = ["No username"]
    @Published var activePosts: [Post] = []
    @Published var claimedPosts: [Post] = []
    @Published var selectedButtons: [UUID: String] = [:]
    @Published var sortOption = 0
    @Published var searchText = ""
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
    var sortedAndFilteredPosts: [Post] {
        var sortedPosts = posts.sorted {
            switch sortOption {
            case 0: return $0.foundLocation < $1.foundLocation
            case 1: return $0.foundLocation > $1.foundLocation
            default: return false
            }
        }

        if !searchText.isEmpty {
            sortedPosts = sortedPosts.filter { $0.itemName.contains(searchText) }
        }

        return sortedPosts
    }
    
    init() {
        loadUsernames()
        let url = Self.dataFileURL
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: url),
           let decoded = try? decoder.decode([Post].self, from: data) {
            self.posts = decoded
        }
    }
    
    func claimPost(at index: Int, by user: String) {
            posts[index].claimed = true
            posts[index].claimedBy = user
        }
    
    private static var dataFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("Posts.data")
    }
    
    func claimPost(at index: Int) {
        posts[index].claimed = true
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
    func deletePost(at index: Int) {
        posts.remove(at: index)
    }
    func loadUsernames() {
        if let url = Bundle.main.url(forResource: "UserCredentials", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([UserCredentials].self, from: data)
                
                for user in jsonData {
                    usernames.append(user.username)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }

}

struct MainView: View {
    @EnvironmentObject var postData: PostData
    @State var username: String
    @State private var activeSheet: ActiveSheet?
    @State private var selectedCategory: Category = .other

    var body: some View {
        NavigationView {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("Search", text: $postData.searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                ScrollView {
                    VStack(spacing: 25) {
                        ForEach(postData.sortedAndFilteredPosts.indices, id: \.self) { index in
                            if postData.sortedAndFilteredPosts[index].category == selectedCategory {
                                BoxView(post: postData.sortedAndFilteredPosts[index], index: index, username: username)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: HStack {
                    Spacer()
                    Text("Welcome, \(username)")
                        .font(.title2)
                    Spacer()
                },
                trailing: HStack(spacing: -5) {
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        activeSheet = .createPost
                    }) {
                        Text("+")
                            .font(.title2)
                            .padding(18)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    Button(action: {
                        activeSheet = .postHistory
                    }) {
                        Text("history")
                            .font(.footnote)
                            .padding(18)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            )
            .sheet(item: $activeSheet) { item in
                switch item {
                case .createPost:
                    CreatePostView(username: $username, posts: $postData.posts)
                        .environmentObject(postData)
                case .postHistory:
                    PostHistoryView(username: username)
                        .environmentObject(postData)
                }
            }
        }
    }
}
struct BoxView: View {
    let post: Post
    @EnvironmentObject var postData: PostData
    var index: Int
    var username: String

    var body: some View {
        if !post.claimed {
            VStack {
                if post.username == username {
                    Button(action: {
                        postData.deletePost(at: index)
                    }) {
                        Image(systemName: "trash")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .offset(x: 150, y: 5)
                    }
                }
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
                if let taggedUsername = post.taggedUsername {
                        Text("Tagged Student: \(taggedUsername)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                    }
                
                Text("Drop off at: \(post.dropOffLocation)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                
                Button(action: {
                    withAnimation {
                        if post.taggedUsername == nil || post.taggedUsername == username {
                            postData.claimPost(at: index, by: username)
                        }
                    }
                }) {
                    Text("Claim")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10.0)
                }
                .disabled(post.taggedUsername != nil && post.taggedUsername != username || post.username == username)
                .padding(.bottom, 10)
            }
            .frame(width: 350)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .transition(.move(edge: .bottom))
        }
    }
}
