import SwiftUI

// MARK: - Game State Manager
class GameState: ObservableObject {
    @Published var playerY: CGFloat = 0
    @Published var playerX: CGFloat = 0
    @Published var playerVelocity: CGFloat = 0
    @Published var score: Int = 0
    @Published var gameActive: Bool = false
    @Published var obstacles: [Obstacle] = []
    
    private var gameTimer: Timer?
    private let gravity: CGFloat = 0.6
    private let jumpStrength: CGFloat = -12
    private let gameWidth: CGFloat = 393 // iPhone width
    private let gameHeight: CGFloat = 852 // iPhone height
    
    let playerWidth: CGFloat = 40
    let playerHeight: CGFloat = 40
    let obstacleWidth: CGFloat = 80
    let obstacleGap: CGFloat = 140
    
    // Game config
    var selectedCharacter: String = "bird"
    var gameName: String = "My Game"
    
    init() {
        resetGame()
    }
    
    func resetGame() {
        playerY = 400
        playerX = 50
        playerVelocity = 0
        score = 0
        gameActive = false
        obstacles = []
        gameTimer?.invalidate()
    }
    
    func startGame() {
        gameActive = true
        resetGame()
        playerY = 400
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.016, block: { _ in
            self.updateGame()
        })
    }
    
    func stopGame() {
        gameActive = false
        gameTimer?.invalidate()
    }
    
    func tap() {
        if gameActive {
            playerVelocity = jumpStrength
        }
    }
    
    private func updateGame() {
        guard gameActive else { return }
        
        // Apply gravity
        playerVelocity += gravity
        playerY += playerVelocity
        
        // Boundary check (death)
        if playerY < 0 || playerY > 800 {
            stopGame()
            return
        }
        
        // Spawn obstacles
        if obstacles.isEmpty || obstacles.last!.x < gameWidth - 200 {
            spawnObstacle()
        }
        
        // Move obstacles
        for i in 0..<obstacles.count {
            obstacles[i].x -= 6
            
            // Collision detection
            if checkCollision(obstacle: obstacles[i]) {
                stopGame()
                return
            }
            
            // Score on pass
            if obstacles[i].x < playerX && !obstacles[i].scored {
                obstacles[i].scored = true
                score += 1
            }
        }
        
        // Remove off-screen obstacles
        obstacles.removeAll { $0.x < -obstacleWidth }
    }
    
    private func spawnObstacle() {
        let topHeight = CGFloat.random(in: 80...300)
        let bottomY = topHeight + obstacleGap
        
        let obstacle = Obstacle(
            id: UUID(),
            x: gameWidth,
            topHeight: topHeight,
            bottomY: bottomY
        )
        obstacles.append(obstacle)
    }
    
    private func checkCollision(obstacle: Obstacle) -> Bool {
        let playerRight = playerX + playerWidth
        let playerBottom = playerY + playerHeight
        
        // Check if player is in obstacle's X range
        guard playerX < obstacle.x + obstacleWidth &&
              playerRight > obstacle.x else {
            return false
        }
        
        // Check collision with top or bottom pipe
        if playerY < obstacle.topHeight ||
           playerBottom > obstacle.bottomY {
            return true
        }
        
        return false
    }
}

// MARK: - Obstacle Model
struct Obstacle: Identifiable {
    let id: UUID
    var x: CGFloat
    let topHeight: CGFloat
    let bottomY: CGFloat
    var scored: Bool = false
}

// MARK: - Game View
struct GameView: View {
    @StateObject private var gameState = GameState()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background (changes by theme)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.8),
                    Color(red: 0.1, green: 0.2, blue: 0.5)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
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
                    PlayerCharacter(character: gameState.selectedCharacter)
                        .frame(width: gameState.playerWidth, height: gameState.playerHeight)
                        .position(
                            x: gameState.playerX + gameState.playerWidth / 2,
                            y: gameState.playerY + gameState.playerHeight / 2
                        )
                    
                    // Obstacles
                    ForEach(gameState.obstacles) { obstacle in
                        // Top pipe
                        Rectangle()
                            .fill(Color.green)
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
                            .fill(Color.green)
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
                .background(Color(red: 0.06, green: 0.09, blue: 0.11))
                .contentShape(Rectangle())
                .onTapGesture {
                    gameState.tap()
                }
            }
            
            // Game Over Overlay
            if !gameState.gameActive && gameState.score > 0 {
                GameOverView(
                    score: gameState.score,
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
        .onAppear {
            gameState.startGame()
        }
        .onDisappear {
            gameState.stopGame()
        }
    }
}

// MARK: - Player Character
struct PlayerCharacter: View {
    let character: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 1.0, green: 0.42, blue: 0.21))
            
            Text(characterEmoji)
                .font(.system(size: 24))
        }
    }
    
    var characterEmoji: String {
        switch character {
        case "bird": return "🐦"
        case "cube": return "🟦"
        case "rocket": return "🚀"
        case "ball": return "⚽"
        case "cat": return "🐱"
        default: return "🐦"
        }
    }
}

// MARK: - Game Over Screen
struct GameOverView: View {
    let score: Int
    let onRestart: () -> Void
    let onShare: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Game Over")
                .font(.system(size: 42, weight: .bold, design: .default))
                .foregroundColor(.white)
            
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
    GameView()
}
