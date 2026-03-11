//
//  ArtistViewModel.swift
//  testingAMAPI
//
//  Created by Daniel Ramirez on 10/03/26.
//

import Foundation
import MusicKit
import Combine

@MainActor
class ArtistViewModel: ObservableObject {
    
    @Published var albums: [Album] = []
    
    func requestPermission() async {
        let status = await MusicAuthorization.request()
        
        print(status) // para verificar
        
        if status == .authorized {
            await fetchAlbums()
        }
    }
    
    func fetchAlbums() async {
        do {
            var request = MusicCatalogSearchRequest(
                term: "Taylor Swift",
                types: [Artist.self]
            )

            request.limit = 1
            
            let response = try await request.response()

            guard let artist = response.artists.first else {
                print("Artist not found")
                return
            }

            let artistWithAlbums = try await artist.with([.albums])

            albums = Array(artistWithAlbums.albums ?? [])
            
            print(albums.count) // verificar
            
        } catch {
            print(error)
        }
    }
}
