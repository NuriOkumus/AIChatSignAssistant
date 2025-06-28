<<<<<<< HEAD
import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let apiClient: APIClient

    init() {
        // Info.plist’ten alıyoruz
        let key = Bundle.main.object(forInfoDictionaryKey: "GeminiAPIKey") as? String ?? ""
        self.apiClient = APIClient(apiKey: key)
    }

    func send(_ text: String) {
        // Kullanıcı mesajı
        messages.append(Message(text: text, isUser: true))

        // Asenkron API çağrısı
        Task {
            do {
                let reply = try await apiClient.send(prompt: text)
                DispatchQueue.main.async {
                    self.messages.append(Message(text: reply, isUser: false))
                }
            } catch {
                DispatchQueue.main.async {
                    self.messages.append(Message(text: "Error: \(error.localizedDescription)", isUser: false))
                }
            }
=======
import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ChatViewModel()
    @State private var inputText = ""

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(vm.messages) { msg in
                        HStack {
                            if msg.isUser { Spacer() }
                            Text(msg.text)
                                .padding()
                                .background(msg.isUser ? Color.blue.opacity(0.7) : Color.gray.opacity(0.3))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                            if !msg.isUser { Spacer() }
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message…", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    let text = inputText.trimmingCharacters(in: .whitespaces)
                    guard !text.isEmpty else { return }
                    vm.send(text)
                    inputText = ""
                }
                .padding(.horizontal)
            }
            .padding()
>>>>>>> feature/chat-ui-skeleton
        }
    }
}
