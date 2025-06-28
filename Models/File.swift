import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []

    func send(_ text: String) {
        // 1. Kullanıcının mesajını ekle
        let userMsg = Message(text: text, isUser: true)
        messages.append(userMsg)

        // 2. Sabit cevabı (dummy) ekle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let botMsg = Message(text: "Hello from Gemini!", isUser: false)
            self.messages.append(botMsg)
        }
    }
}
