import SwiftUI

struct IntroUIView: View {
    @State private var animateContent = false
    @State private var animateBackground = false

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .hueRotation(.degrees(animateBackground ? 15 : -15))

            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .opacity(animateContent ? 1 : 0)
                    .shadow(radius: 12)
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.8),
                        value: animateContent
                    )
                
                Text("Reclaim: Lost And Found")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.1),
                        value: animateContent
                    )
                
                
                Text("Less searching.\nMore finding.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.2),
                        value: animateContent
                    )
                
                Spacer()
                
                
                VStack(spacing: 12) {
                    NavigationLink {
                        LoginPageUIView()
                    } label: {
                        Text("LOG IN")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                    }
                    
                    NavigationLink {
                        SignUpPageUIView()
                    } label: {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 40)
                .animation(
                    .spring(response: 0.7, dampingFraction: 0.9)
                    .delay(0.3),
                    value: animateContent
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onAppear {
            animateContent = true
            animateBackground = true
        }
    }
}

#Preview {
    IntroUIView()
        .preferredColorScheme(.dark)
}
