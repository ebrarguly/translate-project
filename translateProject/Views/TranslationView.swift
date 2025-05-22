import SwiftUI

struct TranslationView: View {
    @State private var sourceText: String = ""
    @State private var translatedText: String = ""
    @State private var showSourceLanguagePicker = false
    @State private var showTargetLanguagePicker = false
    @State private var selectedSourceLanguage: Language?
    @State private var selectedTargetLanguage: Language?
    @State private var showSpeechView = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // Çeviri sonuçlarını tutmak için
    @State private var translations: [String: String] = [:]

    func loadSelectedLanguages() -> [Language] {
        return Language.availableLanguages
    }

    func performTranslation() {
        guard !sourceText.trimmingCharacters(in: .whitespaces).isEmpty else {
            translatedText = "Metin boş olamaz."
            return
        }
        
        guard let sourceLang = selectedSourceLanguage?.code,
              let targetLang = selectedTargetLanguage?.code else {
            translatedText = "Lütfen kaynak ve hedef dili seçin."
            return
        }
        
        isLoading = true
        errorMessage = nil

        APIManager.shared.translate(
            text: sourceText,
            sourceLanguage: sourceLang,
            targetLanguage: targetLang
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let response):
                    if let error = response.error {
                        errorMessage = error
                        translatedText = "Hata: \(error)"
                    } else {
                        translatedText = response.translated
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    translatedText = "Çeviri hatası: \(error.localizedDescription)"
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Üst başlık
                    HStack {
                        NavigationLink(destination: AuthView()) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.theme.textPrimary)
                                .font(.title2)
                        }

                        Text("Metin Çeviri")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                        Spacer()
                        Image(systemName: "bell")
                            .foregroundColor(Color.theme.textPrimary)
                    }
                    .padding()
                    .background(Color.theme.surface)

                    // Dil seçim bölümü
                    HStack {
                        Spacer()
                        Button(action: { showSourceLanguagePicker = true }) {
                            VStack(spacing: 4) {
                                Text(selectedSourceLanguage?.flag ?? "🌍")
                                    .font(.title2)
                                Text(selectedSourceLanguage?.name ?? "Kaynak Dil")
                                    .font(.subheadline)
                                    .foregroundColor(Color.theme.textPrimary)
                            }
                            .frame(width: 100)
                            .padding(.vertical, 8)
                            .background(Color.theme.surface)
                            .cornerRadius(12)
                        }

                        Button(action: {
                            let temp = selectedSourceLanguage
                            selectedSourceLanguage = selectedTargetLanguage
                            selectedTargetLanguage = temp
                        }) {
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundColor(Color.theme.textPrimary)
                                .frame(width: 50)
                                .padding(8)
                                .background(Color.theme.surface)
                                .cornerRadius(12)
                        }

                        Button(action: { showTargetLanguagePicker = true }) {
                            VStack(spacing: 4) {
                                Text(selectedTargetLanguage?.flag ?? "🌍")
                                    .font(.title2)
                                Text(selectedTargetLanguage?.name ?? "Hedef Dil")
                                    .font(.subheadline)
                                    .foregroundColor(Color.theme.textPrimary)
                            }
                            .frame(width: 100)
                            .padding(.vertical, 8)
                            .background(Color.theme.surface)
                            .cornerRadius(12)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)

                    // Çeviri alanları
                    ScrollView {
                        VStack(spacing: 20) {
                            TranslationField(
                                title: "Çeviri Yapılacak Metin",
                                placeholder: "Metin girin...",
                                text: $sourceText
                            )

                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }

                            TranslationField(
                                title: "Çeviri Metni",
                                placeholder: "Çeviri burada görünecek",
                                text: $translatedText,
                                isEditable: false
                            )
                            
                            // Çevir butonu
                            Button(action: performTranslation) {
                                HStack {
                                    Spacer()
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(1.2)
                                    } else {
                                        Image(systemName: "arrow.right.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                        Text("Çevir")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                .frame(height: 50)
                                .background(isLoading ? Color.gray : Color.theme.primary)
                                .cornerRadius(12)
                            }
                            .disabled(isLoading)
                            .padding(.vertical, 20)
                            
                            Spacer(minLength: 40) // Alt menü ile arasına boşluk ekledik
                    }
                    .padding(.horizontal)
                    }

                    // Alt menü
                    HStack(spacing: 0) {
                        Button(action: { showSpeechView = true }) {
                            TabButton(icon: "mic.fill", text: "Speech", iconType: "mic")
                        }

                        TabButton(icon: "textformat", text: "Text", iconType: "text")
                            .foregroundColor(Color.theme.primary)

                        NavigationLink(destination: HistoryView()) {
                            TabButton(icon: "clock.arrow.circlepath", text: "Geçmiş", iconType: "icon")
                        }

                        NavigationLink(destination: ProfileView()) {
                            TabButton(icon: "person", text: "Profile", iconType: "icon")
                        }
                    }
                    .padding(.vertical, 15)
                    .background(Color.theme.surface)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .padding(.bottom, 34)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showSourceLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedSourceLanguage, languages: loadSelectedLanguages())
        }
        .sheet(isPresented: $showTargetLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedTargetLanguage, languages: loadSelectedLanguages())
        }
        .fullScreenCover(isPresented: $showSpeechView) {
            SpeechTranslationView()
        }
    }
}
