import SwiftUI

struct ContentView: View {
    @State var randomPassword = Password(data: "")
    @State var numbers = false
    @State var characters = false
    @State var caps = false
    @State var length = 12.00
    var body: some View {
        VStack (alignment: .leading) {
            Text("Password Generator")
                .font(.system(size: 30, weight: .black, design: .monospaced))
                .foregroundColor(.white)
                .padding()
                .padding(.top)
            
            Spacer()
            
            Text(randomPassword.data)
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("textBackground"))
                .cornerRadius(20)
                .padding()
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Length: \(Int(length))")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                
                HStack {
                    Text("4")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                    Slider(value: $length, in: 4...32, step: 1)
                    Text("32")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                }
            }
            .padding()
            .background(Color("textBackground"))
            .cornerRadius(20)
            .padding()
            
            Group {
                Toggle(isOn: $numbers) {
                    Text("Contain Numbers")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                }
                
                
                Toggle(isOn: $characters) {
                    Text("Contain Special Characters")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                }
                
                
                Toggle(isOn: $caps) {
                    Text("Contain Capital Letters")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                }
            }
            .padding()
            .background(Color("textBackground"))
            .cornerRadius(20)
            .padding()
            
            Spacer()
            
            Button(action: {
                loadData { (password) in
                    self.randomPassword = password
                    
                }
            }) {
                Text("Generate")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("button"))
            .cornerRadius(20)
            .padding()
            
            
        }
        .background(Color("background").edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            loadData { (password) in
                self.randomPassword = password
                
            }
        })
    }
    
    func loadData(completion: @escaping (Password) ->  ()) {
        
        //creating URL
        var api_url = "https://passwordinator.herokuapp.com/generate?"
        if numbers == true {
            api_url.append("num=true&")
        }
        if characters == true {
            api_url.append("char=true&")
        }
        if caps == true {
            api_url.append("caps=true&")
        }
        api_url.append("len=\(Int(length))")
        
        guard let url = URL(string: api_url) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let result = try! JSONDecoder().decode(Password.self, from: data!)
            
            DispatchQueue.main.async {
                print(result)
                completion(result)
            }
        }
        .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Password  : Codable {
    var data : String
}
