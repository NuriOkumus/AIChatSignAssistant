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
        }
    }
}
