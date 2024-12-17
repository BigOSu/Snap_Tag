//
//  PreviewView.swift
//  SnapTag
//
//  Created by Suraj Joshi on 09/10/24.
//

import SwiftUI
import CoreLocation
import Combine

struct PreviewView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: UIImage?
    @State private var currentLocation: String = "Fetching location..."
    @State private var currentWeather: String = "Fetching weather..."
    @State private var locationCoordinates: CLLocationCoordinate2D?
    private let locationManager = LocationManager()
    
    var body: some View {
        VStack {
            // Display the captured image
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
            } else {
                Text("No Image Available")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding()
            }

            // Spacer for visual separation
            Spacer()

            // Display location and weather information
            VStack(spacing: 10) {
                Text(currentLocation)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(currentWeather)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()

            Spacer()

            // Save to Gallery Button
            Button(action: saveImageWithOverlay) {
                Text("Save to Gallery")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)) // Subtle background
        .onAppear {
            fetchLocation()
        }
        .navigationTitle("Preview")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveImageWithOverlay() {
        guard let uiImage = image else { return }
        let overlayText = "\(currentLocation)\n\(currentWeather)"
        if let finalImage = addOverlayText(to: uiImage, text: overlayText) {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            // Navigate back to CameraView
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func addOverlayText(to image: UIImage, text: String) -> UIImage? {
        let textFont = UIFont.boldSystemFont(ofSize: 40) // Increased font size
        let textColor = UIColor.white
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor
        ]
        
        // Calculate text size for dynamic height
        let textSize = text.boundingRect(
            with: CGSize(width: image.size.width - 40, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: textAttributes,
            context: nil
        ).size
        
        let overlayHeight = textSize.height + 40 // Add padding above and below the text
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the original image
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        // Create a blurred black overlay
        let overlayRect = CGRect(
            x: 0,
            y: image.size.height - overlayHeight,
            width: image.size.width,
            height: overlayHeight
        )
        
        context?.saveGState()
        context?.setFillColor(UIColor.black.withAlphaComponent(0.6).cgColor) // Black background with transparency
        context?.fill(overlayRect)
        context?.restoreGState()
        
        // Draw the text
        let textRect = CGRect(
            x: 20,
            y: image.size.height - overlayHeight + 20, // Padding above the text
            width: image.size.width - 40,
            height: textSize.height
        )
        text.draw(in: textRect, withAttributes: textAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }



    private func fetchLocation() {
        locationManager.requestLocation { location, error in
            if let location = location {
                locationCoordinates = location.coordinate
                reverseGeocode(location: location)
            } else if let error = error {
                currentLocation = "Error fetching location: \(error.localizedDescription)"
            }
        }
    }

    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                currentLocation = "Error fetching place name: \(error.localizedDescription)"
                return
            }
            if let placemark = placemarks?.first {
                let placeName = placemark.locality ?? "Unknown city"
                let state = placemark.administrativeArea ?? "Unknown state"
                let country = placemark.country ?? "Unknown country"
                currentLocation = "\(placeName), \(state), \(country)"
                fetchWeather(for: "\(placeName), \(state)")
            } else {
                currentLocation = "No place information available"
            }
        }
    }
    
    private func fetchWeather(for locationName: String) {
        let weatherManager = WeatherManager()
        
        weatherManager.fetchWeather(for: locationName) { weather in
            DispatchQueue.main.async {
                currentWeather = weather
            }
        }
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView(image: UIImage(systemName: "photo"))
    }
}
