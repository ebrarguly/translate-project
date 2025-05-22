import SwiftUI

struct ProfileView: View {
    @State private var showLanguagePreferences = false
    @State private var showSettings = false
    @State private var showHelpSupport = false
    @State private var showFavorites = false
    @State private var showAbout = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Üst başlık
                    HStack {
                        NavigationLink(destination: TranslationView()) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.theme.textPrimary)
                                .font(.title2)
                        }
                        
                        Text("Profil")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                        Spacer()
                    }
                    .padding()
                    .background(Color.theme.surface)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Profil bilgileri
                            VStack(spacing: 16) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(Color.theme.primary)
                                
                                Text("Kullanıcı Adı")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                Text("kullanici@email.com")
                                    .font(.subheadline)
                                    .foregroundColor(Color.theme.textSecondary)
                            }
                            .padding(.vertical, 20)
                            
                            // Menü öğeleri
                            VStack(spacing: 8) {
                                MenuButton(
                                    icon: "globe",
                                    title: "Dil Tercihleri",
                                    action: { showLanguagePreferences = true }
                                )
                                
                                MenuButton(
                                    icon: "star.fill",
                                    title: "Favoriler",
                                    action: { showFavorites = true }
                                )
                                
                                MenuButton(
                                    icon: "gear",
                                    title: "Ayarlar",
                                    action: { showSettings = true }
                                )
                                
                                MenuButton(
                                    icon: "questionmark.circle",
                                    title: "Yardım ve Destek",
                                    action: { showHelpSupport = true }
                                )
                                
                                MenuButton(
                                    icon: "info.circle",
                                    title: "Hakkında",
                                    action: { showAbout = true }
                                )
                            }
                            .padding(.horizontal)
                            
                            // Çıkış yap butonu
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Çıkış Yap")
                                }
                                .foregroundColor(Color.theme.primary)
                                .font(.headline)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.top, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showLanguagePreferences) {
            LanguagePreferencesView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showHelpSupport) {
            HelpSupportView()
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}

struct MenuButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.primary)
                    .frame(width: 30)
                
                Text(title)
                    .foregroundColor(Color.theme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.textSecondary)
            }
            .padding()
            .background(Color.theme.surface)
            .cornerRadius(12)
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Üst başlık
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.theme.textPrimary)
                                .font(.title2)
                        }
                        
                        Spacer()
                        
                        Text("Ayarlar")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.theme.surface)
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            SettingsButton(
                                icon: "bell",
                                title: "Bildirimler",
                                action: {}
                            )
                            
                            SettingsButton(
                                icon: "moon",
                                title: "Karanlık Mod",
                                action: {}
                            )
                            
                            SettingsButton(
                                icon: "lock",
                                title: "Gizlilik",
                                action: {}
                            )
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.primary)
                    .frame(width: 30)
                
                Text(title)
                    .foregroundColor(Color.theme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.textSecondary)
            }
            .padding()
            .background(Color.theme.surface)
            .cornerRadius(12)
        }
    }
}


