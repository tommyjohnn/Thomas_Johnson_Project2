//
//  AddView.swift
//  Project2
//
//  Created by Thomas Johnson on 10/27/25.
//

import SwiftUI


struct AddView: View {
    // Store is passed in so app state updates the main list.
    @State var movieStore: MovieStore
    @Binding var path: NavigationPath

    // List of catalog choices that are not already in the list.
    @State private var available: [Movie] = []
    // The currently selected catalog item
    @State private var selected: Movie? = nil

   
    @State private var isFavorite = false
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var imageName: String = "movie_poster_1"

    var body: some View {
        Form {
            Section(header: Text("Choose a movie to add")) {

                // Presents remaining catalog titles
                Picker("Movie", selection: $selected) {
                    ForEach(available, id: \.id) { m in
                        // Tag with Optional(Movie) so nil is allowed
                        Text(m.name).tag(Optional(m))
                    }
                }
                // When the selection changes, prefill all fields
                .onChange(of: selected) { m in
                    guard let m else { return }
                    name = m.name
                    description = m.description
                    imageName = m.imageName
                }

                // Shows poster and description for the selected item
                if let chosen = selected {
                    Image(chosen.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical, 4)

                    VStack(alignment: .leading) {
                        Text("Description").font(.headline)
                        TextField("", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                            .textFieldStyle(.roundedBorder)
                            .disabled(true) // read-only to indicate it’s prefilled
                    }


                    // Adds a new Movie to the store
                    Button("Add Movie", action: addSelectedMovie)
                        .disabled(selected == nil)
                } else {
                    Text("Select a title to continue.")
                        .foregroundStyle(.secondary)
                }
            }
        }
        // Populates available movies to choose from
        .onAppear(perform: prepareChoices)
    }


    // Builds the choices list from MovieData, excluding any title
    // that already exists in the current list 
    private func prepareChoices() {
        let existing = Set(movieStore.movies.map { $0.name.lowercased() })

        available = MovieData
            .filter { !existing.contains($0.name.lowercased()) }
            .sorted { $0.name < $1.name }

        // Prefill the UI from the first option for a faster flow.
        if selected == nil, let first = available.first {
            selected = first
            name = first.name
            description = first.description
            imageName = first.imageName
        }
    }

    // Appends the selected movie into the store
    // then navigates back to the list
    private func addSelectedMovie() {
        guard selected != nil else { return }

        let newMovie = Movie(
            id: UUID().uuidString,
            name: name,
            description: description,
            isFavorite: isFavorite,
            imageName: imageName
        )

        movieStore.movies.append(newMovie)
        path.removeLast()
    }
}

#Preview("AddView") {
    struct AddViewPreviewHost: View {
        @State var store = MovieStore(movies: [])
        @State var path = NavigationPath()
        var body: some View { AddView(movieStore: store, path: $path) }
    }
    return AddViewPreviewHost()
}

/*
 LLM Help:
 ChatGPT assisted with separating MovieData (the full catalog of available
 movies) from MovieSeed (the initial movies displayed on launch). The
 generated solution created two distinct datasets: one shown on the homepage
 (MovieSeed) and another used by AddView for adding
 new movies without duplication. This helped fix issues where all movies were
 appearing at once and no movies were avalible to add. A future improvement
 could include updating the library to where the user can
 scroll and see all the movies avaible visually instead of just the names.
 */
