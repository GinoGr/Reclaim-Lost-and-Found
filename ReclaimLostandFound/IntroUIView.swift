import SwiftUI

struct IntroUIView: View {
    @State private var animateContent = false //Will be Used to objects in view to move on intro
    @State private var animateBackground = false //Used for background color motion
//@State makes the uiview rerender when state var is updated
    var body: some View {
        ZStack {
            // Home screen graident. Self explained
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .hueRotation(.degrees(animateBackground ? 15 : -15))

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "magnifyingglass.circle.fill") //Logo
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .shadow(radius: 12)
                    .scaleEffect(animateContent ? 1.0 : 0.8) // Scales the image
                    .opacity(animateContent ? 1 : 0) // Make visible only when page appears
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.8),
                        value: animateContent
                    ) //Springs the object into view
                //value is the trigger

                Text("Reclaim: Lost And Found")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 10) //This is the value that will be shifting the object
                    .animation(
                        .easeOut(duration: 0.6).delay(0.1),
                        value: animateContent
                    )//easeOut animates the object fast then slow


                Text("Less searching.\nMore finding.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.2), // how long the animation will take
                        value: animateContent
                    )//

                Spacer()


                VStack(spacing: 12) {
                    NavigationLink { //Used to navigate the new page with a back button
                        LoginPageUIView() //
                    } label: { //Navigation link allows this label to be used as a button
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
