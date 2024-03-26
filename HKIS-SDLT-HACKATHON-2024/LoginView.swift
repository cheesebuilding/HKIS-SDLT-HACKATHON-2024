import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    @State private var isActive: Bool = false
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float  = 0
    @EnvironmentObject var postData: PostData
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)

                VStack {
                    Text("Lost and Found")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                        
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login") {
                        login()
                        }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: MainView(username: username).environmentObject(PostData()), isActive: $isActive) {
                        EmptyView()
                    }
                }
            }.navigationBarHidden(true)
        }
    }
    
    func login() {
        if let url = Bundle.main.url(forResource: "UserCredentials", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([UserCredentials].self, from: data)
                
                for user in jsonData {
                    if user.username == username && user.password == password {
                        loginMessage = "Login Successful"
                        isActive = true
                        return
                    }
                }
                loginMessage = "Please type in the correct student ID / password"
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

struct UserCredentials: Codable {
    let username: String
    let password: String
}
