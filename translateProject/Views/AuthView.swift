import SwiftUI

struct AuthView: View {
    @State private var isShowingLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var navigateToTranslation = false
    @State private var navigateToLanguagePreferences = false
    @State private var showPasswordMismatch = false
    @State private var showForgotPassword = false
    @State private var acceptedTerms = false
    @State private var showTermsAlert = false
    @State private var showTermsSheet = false
    @State private var showPrivacySheet = false
    
    private func handleRegistration() {
        if !acceptedTerms {
            showTermsAlert = true
            return
        }
        
        if password == confirmPassword {
            navigateToLanguagePreferences = true
        } else {
            showPasswordMismatch = true
        }
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Logo ve Başlık
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.theme.primary)
                            .frame(width: 90, height: 90)
                            .overlay(
                                Image("world_flags")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                            )
                        
                        Text("Çeviri Uygulaması")
                            .font(.title2.bold())
                            .foregroundColor(Color.theme.textPrimary)
                    }
                    .padding(.top, 40)
                    
                    // Giriş/Kayıt Seçimi
                    HStack(spacing: 0) {
                        AuthTabButton(title: "Giriş Yap", isSelected: isShowingLogin) {
                            withAnimation { isShowingLogin = true }
                        }
                        AuthTabButton(title: "Kayıt Ol", isSelected: !isShowingLogin) {
                            withAnimation { isShowingLogin = false }
                        }
                    }
                    .background(Color.theme.surface.opacity(0.3))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Form Alanları
                    VStack(spacing: 12) {
                        if !isShowingLogin {
                            ModernTextField(text: $fullName, placeholder: "Ad Soyad", icon: "person")
                        }
                        ModernTextField(text: $email, placeholder: "E-posta", icon: "envelope")
                        ModernTextField(text: $password, placeholder: "Şifre", icon: "lock", isSecure: true)
                        
                        if !isShowingLogin {
                            ModernTextField(text: $confirmPassword, placeholder: "Şifre Tekrar", icon: "lock", isSecure: true)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    if showPasswordMismatch {
                        Text("Şifreler eşleşmiyor!")
                            .foregroundColor(Color.theme.primary)
                            .font(.caption)
                    }
                    
                    // Şifremi Unuttum
                    if isShowingLogin {
                        HStack {
                            Spacer()
                            Button(action: { showForgotPassword = true }) {
                                Text("Şifremi Unuttum")
                                    .font(.subheadline)
                                    .foregroundColor(Color.theme.primary)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Kullanım Koşulları Onay Kutusu (Sadece kayıt ekranında)
                    if !isShowingLogin {
                        HStack(alignment: .center, spacing: 8) {
                            Button(action: { acceptedTerms.toggle() }) {
                                Image(systemName: acceptedTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(Color.theme.primary)
                            }
                            
                            Text("Kullanım Koşulları ve Gizlilik Politikası'nı kabul ediyorum")
                                .font(.footnote)
                                .foregroundColor(Color.theme.textSecondary)
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 4) {
                            Button(action: { showTermsSheet = true }) {
                                Text("Kullanım Koşulları")
                                    .underline()
                            }
                            Text("ve")
                                .foregroundColor(Color.theme.textSecondary)
                            Button(action: { showPrivacySheet = true }) {
                                Text("Gizlilik Politikası")
                                    .underline()
                            }
                        }
                        .font(.caption)
                        .foregroundColor(Color.theme.primary)
                    }
                    
                    // Giriş/Kayıt Butonu
                    Button(action: {
                        if isShowingLogin {
                            navigateToTranslation = true
                        } else {
                            handleRegistration()
                        }
                    }) {
                        Text(isShowingLogin ? "Giriş Yap" : "Kayıt Ol")
                            .font(.headline)
                            .foregroundColor(Color.theme.textPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // Ayraç
                    HStack {
                        Rectangle()
                            .fill(Color.theme.surface)
                            .frame(height: 1)
                        Text("veya")
                            .font(.footnote)
                            .foregroundColor(Color.theme.textSecondary)
                        Rectangle()
                            .fill(Color.theme.surface)
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    // Google ile Giriş
                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Text("G")
                                .font(.title3.bold())
                                .foregroundColor(Color.theme.primary)
                            Text("Google ile Devam Et")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.surface)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
        .alert("Kullanım Koşulları", isPresented: $showTermsAlert) {
            Button("Tamam", role: .cancel) {}
        } message: {
            Text("Devam etmek için kullanım koşullarını ve gizlilik politikasını kabul etmelisiniz.")
        }
        .sheet(isPresented: $showTermsSheet) {
            TermsView()
        }
        .sheet(isPresented: $showPrivacySheet) {
            PrivacyView()
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
        .fullScreenCover(isPresented: $navigateToTranslation) {
            TranslationView()
        }
        .fullScreenCover(isPresented: $navigateToLanguagePreferences) {
            LanguagePreferencesView()
        }
    }
}

// Şifre Sıfırlama View
struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Şifrenizi mi unuttunuz?")
                        .font(.title3.bold())
                        .foregroundColor(Color.theme.textPrimary)
                    
                    Text("E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                ModernTextField(text: $email, placeholder: "E-posta", icon: "envelope")
                    .padding(.top, 20)
                
                Button(action: {
                    // Şifre sıfırlama e-postası gönderme işlemi
                    dismiss()
                }) {
                    Text("Şifre Sıfırlama Bağlantısı Gönder")
                        .font(.headline)
                        .foregroundColor(Color.theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.primary)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Kapat") {
                dismiss()
            })
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

// Kullanım Koşulları View
struct TermsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Kullanım Koşulları")
                    .font(.title2.bold())
                    .padding()
                // Kullanım koşulları içeriği buraya eklenecek
            }
            .navigationBarItems(trailing: Button("Kapat") {
                dismiss()
            })
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

// Gizlilik Politikası View
struct PrivacyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Gizlilik Politikası")
                    .font(.title2.bold())
                    .padding()
                // Gizlilik politikası içeriği buraya eklenecek
            }
            .navigationBarItems(trailing: Button("Kapat") {
                dismiss()
            })
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}
