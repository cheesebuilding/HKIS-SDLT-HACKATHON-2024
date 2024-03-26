import SwiftUI

enum Category: String, CaseIterable, Codable {
    case earphones, wallet, clothing, other
}


struct Post: Codable, Identifiable {
    var id = UUID()
    var username: String
    var foundLocation: String
    var itemName: String
    var dropOffLocation: String
    var selectedImageData: Data?
    var found: Bool = false
    var givenBack: Bool = false
    var claimed: Bool = false
    var claimedBy: String?
    var taggedUsername: String?
    var category: Category
    var otherItemName: String?
    

    var selectedImage: Image? {
        if let data = selectedImageData {
            return Image(uiImage: UIImage(data: data) ?? UIImage())
        }
        return nil
    }
}
struct CreatePostView: View {
    @State private var taggedUsername = ""
    @Binding var username: String
    @State private var itemName = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var foundLocation = ""
    @State private var dropOffLocation = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerDisplayed = false
    @Binding var posts: [Post]
    @EnvironmentObject var postData: PostData
    @State private var selectedUsernameIndex = 0
    @State private var category = Category.other
    @State private var otherItemName = ""

    var body: some View {
           NavigationView {
               Form {
                   Section(header: Text("Item Details")) {
                       Picker("Category", selection: $category) {
                           ForEach(Category.allCases, id: \.self) {
                               Text($0.rawValue.capitalized)
                           }
                       }
                       
                       if category == .other {
                           TextField("Item Name", text: $otherItemName)
                       }
                   }
                   
                   Section(header: Text("Tag Student (Optional)")) {
                       Picker("Username", selection: $selectedUsernameIndex) {
                           ForEach(0..<postData.usernames.filter { $0 != username }.count, id: \.self) {
                               Text(self.postData.usernames.filter { $0 != username }[$0])
                           }
                       }
                   }
                   
                   Section(header: Text("Location Details")) {
                       TextField("Found Location", text: $foundLocation)
                           .onChange(of: foundLocation) { newValue in
                               if newValue.count > 45 {
                                   foundLocation = String(newValue.prefix(45))
                               }
                           }
                       
                       TextField("Drop Off Location", text: $dropOffLocation)
                           .onChange(of: dropOffLocation) { newValue in
                               if newValue.count > 45 {
                                   dropOffLocation = String(newValue.prefix(45))
                               }
                           }
                   }
                   
                   Section {
                       Button(action: {
                           isImagePickerDisplayed = true
                       }) {
                           HStack {
                               Image(systemName: "camera")
                               Text("Take Photo")
                           }
                       }
                       .sheet(isPresented: $isImagePickerDisplayed) {
                           ImagePicker(image: $selectedImage, sourceType: .camera)
                       }
                   }
                   
                   Section {
                       Button(action: {
                           addPost()
                       }) {
                           Text("Post")
                               .foregroundColor(.white)
                               .frame(maxWidth: .infinity, alignment: .center)
                               .padding()
                               .background(Color.blue)
                               .cornerRadius(10)
                       }
                   }
               }
               .navigationBarTitle("Create Post", displayMode: .inline)
           }
       }

    func addPost() {
        let taggedUsername = postData.usernames.filter { $0 != username }[selectedUsernameIndex] == "No username" ? nil : postData.usernames.filter { $0 != username }[selectedUsernameIndex]
        let post = Post(username: username, foundLocation: foundLocation, itemName: category == .other ? otherItemName : itemName, dropOffLocation: dropOffLocation, selectedImageData: selectedImage?.jpegData(compressionQuality: 1.0), taggedUsername: taggedUsername, category: category, otherItemName: category == .other ? otherItemName : nil)
        postData.posts.append(post)
        presentationMode.wrappedValue.dismiss()
    }
}
