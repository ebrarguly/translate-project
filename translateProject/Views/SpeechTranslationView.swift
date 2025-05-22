import SwiftUI

struct SpeechTranslationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isRecording = false
    @State private var recordedText = ""
    @State private var translatedText = ""
    @State private var selectedSourceLanguage: Language?
    @State private var selectedTargetLanguage: Language?
    @State private var showSourceLanguagePicker = false
    @State private var showTargetLanguagePicker = false
    
    func loadSelectedLanguages() -> [Language] {
        if let data = UserDefaults.standard.data(forKey: "selectedLanguages"),
           let languages = try? JSONDecoder().decode([Language].self, from: data) {
            return languages
        }
        return Language.availableLanguages
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Üst başlık
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.theme.textPrimary)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text("Sesli Çeviri")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "gear")
                            .foregroundColor(Color.theme.textPrimary)
                            .font(.title2)
                    }
                }
                .padding()
                
                // Dil seçim bölümü
                HStack {
                    Spacer()
                    Button(action: { showSourceLanguagePicker = true }) {
                        VStack(spacing: 4) {
                            Text(selectedSourceLanguage?.flag ?? "🌍")
                                .font(.title2)
                            Text(selectedSourceLanguage?.name ?? "Dil Seç")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.textPrimary)
                        }
                        .frame(width: 100)
                        .padding(.vertical, 8)
                        .background(Color.theme.surface)
                        .cornerRadius(12)
                    }
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .frame(width: 50)
                    
                    Button(action: { showTargetLanguagePicker = true }) {
                        VStack(spacing: 4) {
                            Text(selectedTargetLanguage?.flag ?? "🌍")
                                .font(.title2)
                            Text(selectedTargetLanguage?.name ?? "Dil Seç")
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
                
                Spacer()
                
                // Kayıt durumu göstergesi
                Text(isRecording ? "Dinleniyor..." : "Konuşmaya başlamak için butona basın")
                    .foregroundColor(Color.theme.textSecondary)
                    .padding(.bottom, 30)
                
                // Kayıt butonu
                Button(action: { isRecording.toggle() }) {
                    Circle()
                        .fill(isRecording ? Color.theme.primary : Color.theme.accent)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "mic.fill")
                                .foregroundColor(Color.theme.textPrimary)
                                .font(.title)
                        )
                        .scaleEffect(isRecording ? 1.1 : 1.0)
                        .animation(.spring(), value: isRecording)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .sheet(isPresented: $showSourceLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedSourceLanguage, languages: loadSelectedLanguages())
        }
        .sheet(isPresented: $showTargetLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedTargetLanguage, languages: loadSelectedLanguages())
        }
    }
}
