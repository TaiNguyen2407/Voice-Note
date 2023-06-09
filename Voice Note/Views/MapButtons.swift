// 
// Created by Anwar Ulhaq on 29.4.2023.
// 
// 

import Foundation
import SwiftUI

/**
    A View that holds all the buttons over Map
 */
struct MapButtons: View {

    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    @State var centerMap = true
    @State var locationIndicator = true
    @EnvironmentObject var mapViewModel: MapViewModel

    var body: some View {
        VStack {
            Button(action: {
                mapViewModel.reCenterRegionToUserLocation()
            }, label: {
                Image(systemName: "location.fill")
                        .font(.system(size: 36))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                        .foregroundColor(Color(buttonColor))
            })
        }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .padding(.bottom, 144)
    }
}