//
//  ContentView.swift
//  ZipGig
//
//  Created by Yanye Velikanova on 12/22/24.
//

// MARK: - Main Controller View
import SwiftUI
import MapKit

struct ContentView: View {
    @State private var selectedButtonIndex: Int = 0
    @State private var services: [SectionData] = [
        SectionData(date: "Tue, Dec 17", items: [
            ServiceItem(name: "Delivery driver", description: "8 hours", rate: "$122.80", image: "Walg", additionalInfo: "Requires valid driver's license.", startTime: "6:00 AM", location: "Downtown NY")
        ]),
        SectionData(date: "Mon, Dec 23", items: [
            ServiceItem(name: "Packer", description: "4 hours", rate: "$126.27", image: "Amaz", additionalInfo: "Experience with fragile items preferred.", startTime: "8:00 AM", location: "Queens"),
            ServiceItem(name: "Dog walker", description: "3 hours", rate: "$60.00", image: "rov", additionalInfo: "Must be comfortable with large dogs. Extra text extra text. extra text extra test test test test test test.", startTime: "10:00 AM", location: "Brooklyn")
        ]),
        SectionData(date: "Mon, Dec 23", items: [
            ServiceItem(name: "Catering waiter", description: "10 hours", rate: "$265.24", image: "wait", additionalInfo: "Prior catering experience required.", startTime: "3:00 PM", location: "Manhattan"),
            ServiceItem(name: "Delivery driver", description: "5 hours", rate: "$200.00", image: "stop", additionalInfo: "Requires own vehicle.", startTime: "5:00 PM", location: "Staten Island"),
            ServiceItem(name: "Night cleaner", description: "7.5 hours", rate: "$400.00", image: "dom", additionalInfo: "Experience with office cleaning preferred.", startTime: "10:00 PM", location: "Bronx"),
            ServiceItem(name: "Caregiver", description: "3 hours", rate: "$185.00", image: "ny", additionalInfo: "Must have caregiving certification.", startTime: "7:00 PM", location: "Harlem")
        ])
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedButtonIndex == 1 { // When the Map button is selected
                    MapView() // Show the MapView
                } else {
                    // Show the list of services when "Available" is selected
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(services) { section in
                                SectionView(date: section.date, items: section.items)
                            }
                        }
                    }
                }
                // Bottom Navigation Bar
                bottomNavigationBar()
            }
            .navigationBarTitle("Available Shifts", displayMode: .inline)
            .navigationBarItems(trailing: Image(systemName: "line.horizontal.3.decrease.circle"))
        }
    }
    
    // Bottom Navigation Bar
    func bottomNavigationBar() -> some View {
        HStack {
            navButton(label: "Available", icon: "mappin.circle.fill", isSelected: selectedButtonIndex == 0) {
                selectedButtonIndex = 0 // When "Available" is clicked
            }
            navButton(label: "Map", icon: "map", isSelected: selectedButtonIndex == 1) {
                selectedButtonIndex = 1 // When "Map" is clicked
            }
            navButton(label: "Shifts", icon: "wrench.and.screwdriver", isSelected: selectedButtonIndex == 2) {
                selectedButtonIndex = 2
            }
            navButton(label: "Payment", icon: "dollarsign.circle", isSelected: selectedButtonIndex == 3) {
                selectedButtonIndex = 3
            }
            navButton(label: "Account", icon: "person.crop.circle", isSelected: selectedButtonIndex == 4) {
                selectedButtonIndex = 4
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
    }
    
    func navButton(label: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(isSelected ? .green : .gray)
            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? .green : .gray)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            action()
        }
    }
}

// MARK: - Map View
struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var locationManager = CLLocationManager()
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .onAppear {
                setupLocationManager()
            }
            .edgesIgnoringSafeArea(.all) // Full screen map
    }
    
    private func setupLocationManager() {
        locationManager.delegate = LocationManagerDelegate { location in
            self.userLocation = location
            if let userLocation = userLocation {
                region.center = userLocation // Center the map on user's location
            }
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Location Manager Delegate
class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    var locationUpdate: (CLLocationCoordinate2D) -> Void
    
    init(locationUpdate: @escaping (CLLocationCoordinate2D) -> Void) {
        self.locationUpdate = locationUpdate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        locationUpdate(newLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
}

// MARK: - Section View
struct SectionView: View {
    let date: String
    @State var items: [ServiceItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Date Section
            HStack {
                Text(date) // Display the section date
                    .font(.subheadline)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)

            // List of Items
            ForEach($items) { $item in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        // Circular Image Placeholder
                        Image(item.image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                            .padding(.trailing, 10)

                        // Basic Info
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()

                        // Rate and Arrow Icon
                        VStack(alignment: .trailing, spacing: 5) {
                            Text(item.rate)
                                .font(.headline)
                                .foregroundColor(.green)

                            // Arrow Icon to Indicate Expandable
                            Image(systemName: item.isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            item.isExpanded.toggle()
                        }
                    }

                    // Expanded View (Additional Info and Request Button)
                    if item.isExpanded {
                        VStack(alignment: .leading, spacing: 10) {
                            // Additional Info
                            Text("Additional Info:")
                                .font(.subheadline)
                                .bold()
                            Text(item.additionalInfo)
                            Text("Start time: \(item.startTime)")
                            Text("Location: \(item.location)")

                            // Request Button
                            Button(action: {
                                // Add your request action here
                            }) {
                                Text("Request")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal)
                                    .background(Color.green)
                                    .cornerRadius(5)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6).opacity(0.5))
                        .cornerRadius(10)
                    }
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
            }
        }
    }
}

// MARK: - Models
struct SectionData: Identifiable {
    let id = UUID()
    let date: String
    var items: [ServiceItem]
}

struct ServiceItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let rate: String
    let image: String
    let additionalInfo: String
    let startTime: String
    let location: String
    var isExpanded: Bool = false
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
