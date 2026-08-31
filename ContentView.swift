import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Dark base background
            Color(red: 0.06, green: 0.09, blue: 0.11)
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                // Home Tab - Leaderboard Hero
                HomeView()
                    .tag(0)
                
                // Make Tab
                CustomizeView()
                    .tag(1)
                
                // My Games Tab
                MyGamesView()
                    .tag(2)
                
                // Leaderboard Tab
                LeaderboardView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

// MARK: - Home View (Leaderboard Hero)
struct HomeView: View {
    @State private var topGames: [GameEntry] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Top Games")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    
                    Text("This Week")
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                
                // Top 3 Games (Leaderboard Hero)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(Array(topGames.prefix(3).enumerated()), id: \.element.id) { index, game in
                            GameLeaderboardCard(
                                rank: index + 1,
                                game: game,
                                isHighlight: index == 0
                            )
                        }
                        
                        // "Make Your Own" CTA
                        VStack(spacing: 12) {
                            Text("Ready to create?")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            
                            NavigationLink(destination: CustomizeView()) {
                                HStack {
                                    Text("Make Your Own Game")
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 1.0, green: 0.42, blue: 0.21)) // #FF6B35
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 32)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .onAppear {
            loadTopGames()
        }
    }
    
    private func loadTopGames() {
        // Mock data for MVP
        topGames = [
            GameEntry(id: 1, name: "Spike Runner", creatorName: "Alex", plays: 1234, rating: 4.8, score: 456),
            GameEntry(id: 2, name: "Space Tap", creatorName: "Jordan", plays: 892, rating: 4.2, score: 389),
            GameEntry(id: 3, name: "Dino Jump", creatorName: "Casey", plays: 734, rating: 4.9, score: 612)
        ]
    }
}

// MARK: - Game Leaderboard Card
struct GameLeaderboardCard: View {
    let rank: Int
    let game: GameEntry
    let isHighlight: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Rank Badge
                Text("\(rank)")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(rank == 1 ? Color(red: 1.0, green: 0.42, blue: 0.21) : .gray)
                    .frame(width: 50)
                
                // Game Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.name)
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    
                    Text("by \(game.creatorName)")
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Score & Rating
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(game.plays)K plays")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(Color(red: 0.0, green: 0.85, blue: 1.0)) // #00D9FF
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                        Text("\(String(format: "%.1f", game.rating))")
                            .font(.system(size: 12, weight: .semibold, design: .default))
                    }
                    .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.10, green: 0.12, blue: 0.18))
            .cornerRadius(8)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isHighlight ? Color(red: 1.0, green: 0.42, blue: 0.21) : Color.clear,
                    lineWidth: isHighlight ? 2 : 0
                )
        )
    }
}

// MARK: - Placeholder Views
struct CustomizeView: View {
    var body: some View {
        VStack {
            Text("Customize")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.06, green: 0.09, blue: 0.11))
    }
}

struct MyGamesView: View {
    var body: some View {
        VStack {
            Text("My Games")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.06, green: 0.09, blue: 0.11))
    }
}

struct LeaderboardView: View {
    var body: some View {
        VStack {
            Text("Leaderboard")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.06, green: 0.09, blue: 0.11))
    }
}

// MARK: - Data Models
struct GameEntry: Identifiable {
    let id: Int
    let name: String
    let creatorName: String
    let plays: Int
    let rating: Double
    let score: Int
}

#Preview {
    ContentView()
}
