import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    @State private var isActive: Bool = false
    @EnvironmentObject var postData: PostData
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Lost and Found")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                    .offset(y:50)
                
                Spacer()
                VStack {
                    TextField("Student Name", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    SecureField("Student ID", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 32)
                
                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color(red: 66/255, green: 124/255, blue: 1))
                        .cornerRadius(15.0)
                }
                Spacer()

                Text(loginMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 20)
                
                NavigationLink(destination: MainView(username: username).environmentObject(PostData()), isActive: $isActive) {
                    EmptyView()
                }
            }
            .padding()
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

#Preview {
    
    LoginView()
    
}
