import Foundation

class TranslationService {
    private let baseURL = "http://localhost:5050"
    
    struct TranslationResponse: Codable {
        let input: String
        let translated: String
        let error: String?
        let method: String
        let sourceLanguage: Language
        let targetLanguage: Language
        
        enum CodingKeys: String, CodingKey {
            case input
            case translated
            case error
            case method
            case sourceLanguage = "source_language"
            case targetLanguage = "target_language"
        }
    }
    
    func translate(text: String, from sourceLang: String, to targetLang: String) async throws -> TranslationResponse {
        guard let url = URL(string: "\(baseURL)/translate") else {
            throw URLError(.badURL)
        }
        
        let requestBody: [String: String] = [
            "text": text,
            "source_lang": sourceLang,
            "target_lang": targetLang
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
               let errorMessage = errorResponse["error"] {
                throw NSError(domain: "TranslationError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(TranslationResponse.self, from: data)
    }
    
    func checkHealth() async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/health") else {
            throw URLError(.badURL)
        }
        
        let (_, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return httpResponse.statusCode == 200
    }
} 