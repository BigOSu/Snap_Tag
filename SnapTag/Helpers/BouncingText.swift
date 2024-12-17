//
//  BouncingText.swift
//  SnapTag
//
//  Created by Suraj Joshi on 28/09/24.
//

import SwiftUI

struct BouncingTextStyle {
    
    var font: Font
    var color: Color
    var offsetYForBounce: CGFloat
    var dropSpeed: Double
    var opacity: CGFloat
}

struct BouncingText: View {
    
    // MARK: - Stored Properties
    private var characters: Array<String.Element>
    
    // MARK: - Wrapped Properties
    @State private var style: BouncingTextStyle
    
    init(text: String, style: BouncingTextStyle) {
        self.characters = Array(text)
        self.style = style
    }
    
    var body: some View {
        HStack(spacing:0){
            ForEach(0..<characters.count) { num in
                Text(String(characters[num]))
                    .font(style.font)
                    .foregroundColor(style.color)
                    .offset(x: 0.0, y: style.offsetYForBounce)
                    .opacity(style.opacity)
                    .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.1).delay(Double(num) * style.dropSpeed), value: style.offsetYForBounce)
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    style.opacity = 1
                    style.offsetYForBounce = 0
                }
            }
        }
    }
}

// MARK: - Previews
struct BouncingText_Previews: PreviewProvider {
    
    static var previews: some View {
        BouncingText(text: "SnapTag",
                     style: BouncingTextStyle(font: Font(.init(.alertHeader,
                                                               size: 50)),
                                              color: .black,
                                              offsetYForBounce: -50,
                                              dropSpeed: 0.1,
                                              opacity: 0))
    }
}

