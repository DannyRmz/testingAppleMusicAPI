//
//  ArtistView.swift
//  testingAMAPI
//
//  Created by Daniel Ramirez on 10/03/26.
//

import SwiftUI
import MusicKit

struct ArtistView: View {
    
    @StateObject var viewModel = ArtistViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.albums, id: \.id) { album in
                
                HStack(spacing: 15) {
                    
                    AsyncImage(
                        url: album.artwork?.url(width: 200, height: 200)
                    ) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(album.title)
                            .font(.headline)
                        
                        Text(album.artistName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if let date = album.releaseDate {
                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Taylor Swift Albums")
        }
        .task {
            await viewModel.requestPermission()
        }
    }
}
