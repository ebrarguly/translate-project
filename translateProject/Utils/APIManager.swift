import Foundation

class APIManager {
    static let shared = APIManager()

    // API base URL'ini burada tanımlayalım
    #if DEBUG
    private let baseURL = "http://127.0.0.1:5050"  // Geliştirme ortamı için
    #else
    private let baseURL = "http://your-production-server.com"  // Production ortamı için
    #endif
    
    struct TranslationResponse: Codable {
        let input: String
        let translated: String
        let error: String?
    }
    
    func translate(text: String, sourceLanguage: String, targetLanguage: String, completion: @escaping (Result<TranslationResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/translate") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Geçersiz URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "text": text,
            "source_lang": sourceLanguage,
            "target_lang": targetLanguage
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Veri alınamadı"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TranslationResponse.self, from: data)
                completion(.success(response))
            } catch {
                // JSON parse hatası durumunda orijinal yanıtı kontrol edelim
                if let responseText = String(data: data, encoding: .utf8) {
                    print("⚠️ API Yanıtı:", responseText)
                }
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
