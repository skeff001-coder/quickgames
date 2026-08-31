import SwiftUI

struct CustomizeFullView: View {
    @State private var selectedCharacter = "bird"
    @State private var selectedTheme = "sky"
    @State private var gameName = ""
    @State private var showGameView = false
    @StateObject private var gameState = GameState()
    
    let characters = [
        ("bird", "🐦", "Bird"),
        ("cube", "🟦", "Cube"),
        ("rocket", "🚀", "Rocket"),
        ("ball", "⚽", "Ball"),
        ("cat", "🐱", "Cat (Locked)")
    ]
    
    let themes = [
        ("sky", "Sky", "🌤️"),
        ("space", "Space", "🌌"),
        ("neon", "Neon", "⚡"),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.06, green: 0.09, blue: 0.11)
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Create Your Game")
                                .font(.system(size: 32, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            
                            Text("Pick your character and theme")
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        
                        // Character Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pick Your Character")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    ForEach(Array(characters.prefix(3)), id: \.0) { char in
                                        CharacterButton(
                                            emoji: char.1,
                                            name: char.2,
                                            isSelected: selectedCharacter == char.0,
                                            isLocked: char.2.contains("Locked")
                                        ) {
                                            if !char.2.contains("Locked") {
                                                selectedCharacter = char.0
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                
                                HStack(spacing: 12) {
                                    ForEach(Array(characters.suffix(2)), id: \.0) { char in
                                        CharacterButton(
                                            emoji: char.1,
                                            name: char.2,
                                            isSelected: selectedCharacter == char.0,
                                            isLocked: char.2.contains("Locked")
                                        ) {
                                            if !char.2.contains("Locked") {
                                                selectedCharacter = char.0
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Theme Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pick Your Theme")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                ForEach(themes, id: \.0) { theme in
                                    Button(action: {
                                        selectedTheme = theme.0
                                    }) {
                                        VStack(spacing: 8) {
                                            Text(theme.2)
                                                .font(.system(size: 28))
                                            
                                            Text(theme.1)
                                                .font(.system(size: 11, weight: .semibold, design: .default))
                                                .foregroundColor(.white)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            selectedTheme == theme.0 ?
                                            Color(red: 1.0, green: 0.42, blue: 0.21) :
                                            Color(red: 0.10, green: 0.12, blue: 0.18)
                                        )
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Game Name Input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Game Name")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                            
                            TextField("", text: $gameName, prompt: Text("Give your game a name").foregroundColor(.gray))
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                                .cornerRadius(8)
                                .submitLabel(.done)
                        }
                        .padding(.horizontal, 20)
                        
                        // Character Preview
                        VStack(spacing: 12) {
                            Text("Your character:")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                            
                            PlayerCharacter(character: selectedCharacter)
                                .frame(width: 60, height: 60)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        
                        // Start Game Button
                        NavigationLink(destination: GameViewContainer(
                            selectedCharacter: selectedCharacter,
                            gameName: gameName.isEmpty ? "My Game" : gameName,
                            selectedTheme: selectedTheme
                        )) {
                            HStack {
                                Text("Start Playing")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                gameName.isEmpty ?
                                Color.gray.opacity(0.3) :
                                Color(red: 1.0, green: 0.42, blue: 0.21)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .disabled(gameName.isEmpty)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Character Button Component
struct CharacterButton: View {
    let emoji: String
    let name: String
    let isSelected: Bool
    let isLocked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(
                            isSelected ?
                            Color(red: 1.0, green: 0.42, blue: 0.21) :
                            Color(red: 0.10, green: 0.12, blue: 0.18)
                        )
                    
                    Text(emoji)
                        .font(.system(size: 24))
                    
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.red)
                            .clipShape(Circle())
                            .padding(2)
                    }
                }
                
                Text(name.replacingOccurrences(of: " (Locked)", with: ""))
                    .font(.system(size: 10, weight: .semibold, design: .default))
                    .foregroundColor(isSelected ? Color(red: 1.0, green: 0.42, blue: 0.21) : .gray)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .opacity(isLocked ? 0.5 : 1.0)
        }
    }
}

// MARK: - Game View Container
struct GameViewContainer: View {
    let selectedCharacter: String
    let gameName: String
    let selectedTheme: String
    
    @StateObject private var gameState = GameState()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            themeBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Score display
                HStack {
                    Text("\(gameState.score)")
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                
                // Game area
                ZStack {
                    // Player
                    PlayerCharacter(character: selectedCharacter)
                        .frame(width: gameState.playerWidth, height: gameState.playerHeight)
                        .position(
                            x: gameState.playerX + gameState.playerWidth / 2,
                            y: gameState.playerY + gameState.playerHeight / 2
                        )
                    
                    // Obstacles
                    ForEach(gameState.obstacles) { obstacle in
                        // Top pipe
                        Rectangle()
                            .fill(Color(red: 0.2, green: 0.8, blue: 0.2))
                            .frame(
                                width: gameState.obstacleWidth,
                                height: obstacle.topHeight
                            )
                            .position(
                                x: obstacle.x + gameState.obstacleWidth / 2,
                                y: obstacle.topHeight / 2
                            )
                        
                        // Bottom pipe
                        Rectangle()
                            .fill(Color(red: 0.2, green: 0.8, blue: 0.2))
                            .frame(
                                width: gameState.obstacleWidth,
                                height: 800 - obstacle.bottomY
                            )
                            .position(
                                x: obstacle.x + gameState.obstacleWidth / 2,
                                y: obstacle.bottomY + (800 - obstacle.bottomY) / 2
                            )
                    }
                }
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    gameState.tap()
                }
            }
            
            // Game Over Overlay
            if !gameState.gameActive && gameState.score > 0 {
                GameOverFullView(
                    score: gameState.score,
                    gameName: gameName,
                    onRestart: {
                        gameState.startGame()
                    },
                    onShare: {
                        // Share logic
                    },
                    onBack: {
                        dismiss()
                    }
                )
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            gameState.selectedCharacter = selectedCharacter
            gameState.gameName = gameName
            gameState.startGame()
        }
        .onDisappear {
            gameState.stopGame()
        }
    }
    
    @ViewBuilder
    var themeBackground: some View {
        switch selectedTheme {
        case "sky":
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.8),
                    Color(red: 0.1, green: 0.2, blue: 0.5)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "space":
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.0, blue: 0.2),
                    Color(red: 0.1, green: 0.0, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "neon":
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4),
                    Color(red: 0.3, green: 0.0, blue: 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            Color(red: 0.06, green: 0.09, blue: 0.11)
        }
    }
}

// MARK: - Game Over Screen
struct GameOverFullView: View {
    let score: Int
    let gameName: String
    let onRestart: () -> Void
    let onShare: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Game Over")
                .font(.system(size: 42, weight: .bold, design: .default))
                .foregroundColor(.white)
            
            Text(gameName)
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("Score")
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                
                Text("\(score)")
                    .font(.system(size: 64, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(red: 0.0, green: 0.85, blue: 1.0))
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onRestart) {
                    Text("Play Again")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 1.0, green: 0.42, blue: 0.21))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: onShare) {
                    Text("Share Score")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: onBack) {
                    Text("Back")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.clear)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(red: 0.06, green: 0.09, blue: 0.11)
                .opacity(0.95)
        )
    }
}

#Preview {
    CustomizeFullView()
}
