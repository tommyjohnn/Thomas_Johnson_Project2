//
//  ContentView.swift
//  Project2
//
//  Created by Thomas Johnson on 10/27/25.
//

import SwiftUI


// Defines a single movie item
struct Movie: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var isFavorite: Bool
    var imageName: String
}

// Observable class that holds an array of Movie objects
// Automatically updates any view that depends on it when data changes
@Observable
final class MovieStore: Identifiable {
    var movies: [Movie]
    init(movies: [Movie] = []) { self.movies = movies }
}


struct ContentView: View {
    // loads the movies defined in MovieSeed
    @State private var movieStore = MovieStore(movies: MovieData)
    @State private var stackPath = NavigationPath()  // Handles back/forward navigation state.
    
    // Replaces the default store with MovieSeed on launch
    init() {
        _movieStore = State(initialValue: MovieStore(movies: MovieSeed))
    }

    var body: some View {
        NavigationStack(path: $stackPath) {
            
            List {
                // Displays all movies in the store
                ForEach(movieStore.movies) { movie in
                    // Each list item links to a detail view for that specific movie
                    NavigationLink(value: movie) {
                        ListCell(movie: movie)
                    }
                }
                // Enables deleting and reordering of movies
                .onDelete(perform: deleteMovies)
                .onMove(perform: moveItems)
            }

            // Destination when a specific Movie is selected
            .navigationDestination(for: Movie.self) { movie in
                // Finds the matching movie and binds it to DetailView
                if let index = movieStore.movies.firstIndex(where: { $0.id == movie.id }) {
                    DetailView(movie: $movieStore.movies[index])
                } else {
                    // Fallback text in case the movie somehow isn’t found
                    Text("Movie not found")
                }
            }

            // Destination when the “Add Movie” button is pressed
            .navigationDestination(for: String.self) { _ in
                AddView(movieStore: movieStore, path: $stackPath)
            }

            .navigationTitle(Text("Movies"))
            .toolbar {
                // The "Add Movie" feature
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(value: "Add Movie") { Text("Add") }
                }
                // The "Delete Movie" feature
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }
        }
    }

    // Deletes a movie from the list using the swipe-to-delete mechanism
    func deleteMovies(at offsets: IndexSet) {
        movieStore.movies.remove(atOffsets: offsets)
    }

    // Reorders movies in the list via drag-and-drop
    func moveItems(from source: IndexSet, to destination: Int) {
        movieStore.movies.move(fromOffsets: source, toOffset: destination)
    }
}

// Defines how each movie appears in the list (poster + title)
struct ListCell: View {
    var movie: Movie
    var body: some View {
        HStack {
            // Load and display the movie poster from the asset catalog
            Image(movie.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // Show the movie title next to the image
            Text(movie.name)
                .font(.headline)
                .padding(.leading, 5)
        }
    }
}


#Preview {
    ContentView()
}



/*
 LLM Help:
 ChatGPT was used to assist with the implementation of launching MovieSeed
 as the initial dataset displayed on the home screen.
 This was a core issue spreading across ContentView and AddView.
 I was having trouble seperating the original movie list from all the movies
 that could be added. With it's help I was able to successfully launch and show
 ONLY the first 5 movies in the homepage, rather than all 9.
 Future improvement could include adding custom filtering logic to only show
 select few of the movies already added.
 */
