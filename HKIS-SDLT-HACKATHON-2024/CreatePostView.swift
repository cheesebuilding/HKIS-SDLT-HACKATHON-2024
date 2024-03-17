import SwiftUI

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
    
    

    var selectedImage: Image? {
        if let data = selectedImageData {
            return Image(uiImage: UIImage(data: data) ?? UIImage())
        }
        return nil
    }
}
struct CreatePostView: View {
    @Binding var username: String
    @State private var itemName = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var foundLocation = ""
    @State private var dropOffLocation = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerDisplayed = false
    @Binding var posts: [Post]

    var body: some View {
        VStack {
            TextField("Item Name", text: $itemName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            VStack(alignment: .leading) {
                Text("Found at:")
                    .font(.headline)
                TextField("Found Location", text: $foundLocation)
                    .onChange(of: foundLocation) { newValue in
                        if newValue.count > 45 {
                            foundLocation = String(newValue.prefix(45))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
            }

            VStack(alignment: .leading) {
                Text("Drop off at:")
                    .font(.headline)
                TextField("Drop Off Location", text: $dropOffLocation)
                    .onChange(of: dropOffLocation) { newValue in
                        if newValue.count > 45 {
                            dropOffLocation = String(newValue.prefix(45))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
            }
            Button(action: {
                isImagePickerDisplayed = true
            }) {
                Text("Take Photo")
            }
            .sheet(isPresented: $isImagePickerDisplayed) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }

            Button(action: {
                addPost()
            }) {
                Text("Post")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color(red: 66/255, green: 124/255, blue: 1))
                    .cornerRadius(10.0)
            }
            .disabled(itemName.isEmpty || foundLocation.isEmpty || dropOffLocation.isEmpty || selectedImage == nil)
            .padding(.top, 20)
        }
        .padding()
    }

    func addPost() {
        let post = Post(username: username, foundLocation: foundLocation, itemName: itemName, dropOffLocation: dropOffLocation, selectedImageData: selectedImage?.jpegData(compressionQuality: 1.0))
        posts.append(post)
        presentationMode.wrappedValue.dismiss()
    }
}
#Preview {
    CreatePostView(username: .constant("Test User"), posts: .constant([Post(username: "Test User", foundLocation: "Location", itemName: "Item", dropOffLocation: "Drop Off Location")]))
}
