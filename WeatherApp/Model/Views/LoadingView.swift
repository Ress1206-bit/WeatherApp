//
//  LoadView.swift
//  WeatherApp
//
//  Created by Adam Ress on 6/2/24.
//

import SwiftUI
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .black))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(2)
    }
}
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
