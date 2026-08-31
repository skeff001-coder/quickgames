import SwiftUI

struct ShareFullView: View {
    let score: Int
    let gameName: String
    let playerName: String = "You"
    
    @State private var showCopiedToast = false
    @State private var shareLink = "https://quickgames.app/share/game123"
    
    // Mock friend data
    let friendBestScore = 456
    let friendName = "Alex"
    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.09, blue: 0.11)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .center, spacing: 8) {
                        Text("You scored")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                        
                        Text("\(score)")
                            .font(.system(size: 64, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 0.0, green: 0.85, blue: 1.0))
                        
                        Text("in \(gameName)")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    
                    // Friend Challenge
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.0, green: 0.85, blue: 1.0))
                            
                            Text("\(friendName)'s best: \(friendBestScore)")
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            if score > friendBestScore {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                    Text("You're ahead!")
                                        .font(.system(size: 11, weight: .semibold, design: .default))
                                }
                                .foregroundColor(.yellow)
                            } else {
                                Text("Get \(friendBestScore - score) more to beat them")
                                    .font(.system(size: 11, weight: .semibold, design: .default))
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    
                    // QR Code Section
                    VStack(spacing: 16) {
                        Text("Scan to Play")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(.gray)
                        
                        // Placeholder QR Code (in real app, generate actual QR)
                        ZStack {
                            Color(red: 0.10, green: 0.12, blue: 0.18)
                            
                            VStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    ForEach(0..<6, id: \.self) { _ in
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: 16, height: 16)
                                    }
                                }
                                
                                HStack(spacing: 4) {
                                    ForEach(0..<6, id: \.self) { _ in
                                        Rectangle()
                                            .fill([Color.white, Color.clear].randomElement()!)
                                            .frame(width: 16, height: 16)
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
                        .cornerRadius(12)
                        
                        Text("Friends scan code to play")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    
                    // Link Sharing
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Text(shareLink)
                                .font(.system(size: 12, weight: .regular, design: .monospaced))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Button(action: {
                                UIPasteboard.general.string = shareLink
                                showCopiedToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showCopiedToast = false
                                }
                            }) {
                                Image(systemName: "doc.on.doc.fill")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(red: 0.0, green: 0.85, blue: 1.0))
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                        .cornerRadius(6)
                    }
                    .padding(.horizontal, 20)
                    
                    // Share Buttons
                    VStack(spacing: 10) {
                        ShareButton(
                            icon: "message.fill",
                            title: "Share via Message",
                            color: Color(red: 0.0, green: 0.85, blue: 1.0)
                        ) {
                            // Share action
                        }
                        
                        ShareButton(
                            icon: "heart.fill",
                            title: "Share to Stories",
                            color: Color(red: 1.0, green: 0.42, blue: 0.21)
                        ) {
                            // Share action
                        }
                        
                        ShareButton(
                            icon: "square.and.arrow.up",
                            title: "More Options",
                            color: .gray
                        ) {
                            // Share action
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Rank Display
                    VStack(spacing: 12) {
                        HStack {
                            Text("Global Rank")
                                .font(.system(size: 12, weight: .semibold, design: .default))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("#47")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(red: 0.0, green: 0.85, blue: 1.0))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                        .cornerRadius(8)
                        
                        Text("You're in the top 1% of players this week")
                            .font(.system(size: 11, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
            
            // Copy toast
            if showCopiedToast {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Link copied!")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.2, green: 0.8, blue: 0.2))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - Share Button Component
struct ShareButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(red: 0.10, green: 0.12, blue: 0.18))
            .cornerRadius(8)
        }
    }
}

// MARK: - Share Preview
struct SharePreview: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Share Preview Card")
                .font(.system(size: 16, weight: .bold, design: .default))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Alex scored 456")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                        
                        Text("in Spike Runner")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("456")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(red: 0.0, green: 0.85, blue: 1.0))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                .cornerRadius(8)
                
                Text("Can you beat their score? Tap to play →")
                    .font(.system(size: 11, weight: .regular, design: .default))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.06, green: 0.09, blue: 0.11))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 1.0, green: 0.42, blue: 0.21), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ShareFullView()
}
