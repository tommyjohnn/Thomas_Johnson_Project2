//
//  DetailView.swift
//  Project2
//
//  Created by Thomas Johnson on 10/27/25.
//

import SwiftUI

// Displays detailed information about a selected movie, (poster, description, favorite-status
struct DetailView: View {
  
    @Binding var movie: Movie // allows this view to modify the selected movie                           direcly in the MovieStore

    var body: some View {
        Form {
            Section {
                // Displays the movie poster using its asset name
                Image(movie.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // adds rounded corners
                    .padding(.vertical)

                // Shows the plot or summary of the movie
                Text(movie.description)
                    .font(.body)
                    .padding(.bottom, 8)

                // Button for display purposes only
                Button(action: {}) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                        Text("Play")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity) // centers horizontally
                }
                .buttonStyle(.borderedProminent) // gives it a filled button look
                .tint(.blue)                     // sets the button color
                .padding(.vertical, 6)

                // Allows user to toggle the "Favorite" state interactively
                Toggle(isOn: $movie.isFavorite) {
                    Text("Favorite")
                        .font(.headline)
                }
                .toggleStyle(.switch) // displays as an iOS-style switch
            }
        }

        // Displays the movie’s title in the navigation bar
        .navigationTitle(movie.name)
        .navigationBarTitleDisplayMode(.inline) // keeps title compact at the top
    }
}


#Preview {
    struct DetailHost: View {
        // Local sample movie for testing the DetailView layout.
        @State var sample = Movie(
            id: "demo",
            name: "Preview Movie",
            description: "A sample description for preview.",
            isFavorite: true,
            imageName: "movie_poster_1"
        )
        var body: some View { DetailView(movie: $sample) }
    }
    return DetailHost()
}


/*
 LLM Help:
 ChatGPT assisted with adding the "Play" button feature in the DetailView.
 The generated code helped implement a visually styled button using
 system icons.
 The button currently serves as asetheic feature.
 A possible improvement would be to connect this button to actual media
 playback or a trailer preview in later versions.
 */
