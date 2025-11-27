import SwiftUI
import CoreLocation
internal import Combine

struct CreateRoomUIView: View {
    @State private var roomNumber = ""
    @State private var roomPass = ""
    
    @State private var useExpiration = false
    @State private var expirationDate = Date()
    
    @State private var useLocation = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Create Room")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)

                VStack(spacing: 16) {
                    Spacer()
                    
                    VStack() {
                        Text("Room Number")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        TextField("", text: $roomNumber)
                            .placeholder(when: roomNumber.isEmpty) {
                                Text("Enter Room Number")
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal, 12)
                            }
                            .roomTextFieldStyle()
                    }
                    
                    VStack() {
                        Text("Room Password")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        TextField("", text: $roomPass)
                            .placeholder(when: roomPass.isEmpty) {
                                Text("Enter Room Password")
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal, 12)
                            }
                            .roomTextFieldStyle()
                    }
                    
                    Toggle("Add Expiration Date", isOn: $useExpiration)
                        .toggleStyle(SwitchToggleStyle(tint: .purple))
                        .padding(.horizontal)
                    
                    if useExpiration {
                        DatePicker (
                            "Expiration",
                            selection: $expirationDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                        .padding(.horizontal)
                    }
                    
                    Toggle("Attach Location", isOn: $useLocation)
                        .toggleStyle(SwitchToggleStyle(tint: .purple))
                        .padding(.horizontal)
                        .onChange(of: useLocation) {value in
                            if value {
                                locationManager.requestLocation()
                            }
                        }
                    
                    if useLocation {
                        if let coord = locationManager.lastCoordinate {
                            Text("Location: \(coord.latitude), \(coord.longitude)")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal)
                        } else {
                            Text("Getting location...")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        print("Create Room tapped")
                    }) {
                        HStack {
                            Text("Create Room")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

#Preview {
    CreateRoomUIView()
        .preferredColorScheme(.dark)
}


final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var lastCoordinate: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestLocation() {
        // Make sure you added NSLocationWhenInUseUsageDescription to Info.plist
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastCoordinate = locations.last?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
