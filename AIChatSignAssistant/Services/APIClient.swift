import Foundation

// 1. Gelen JSON’u decode edecek model
struct ChatResponse: Decodable {
    let reply: String
}

// 2. Hata çeşitleri
enum APIClientError: Error {
    case invalidURL, invalidResponse, invalidData
}

// 3. Asenkron Gemini istemcisi
class APIClient {
    private let apiKey: String
    private let baseURL = URL(string: "https://api.gemini.com/v1/chat")!  // Örnek URL

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func send(prompt: String) async throws -> String {
        var req = URLRequest(url: baseURL)
        req.httpMethod = "POST"
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["prompt": prompt]
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else {
            throw APIClientError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
        return decoded.reply
    }
}
