//
//  PokemonInfoView.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 2.09.22.
//

import SwiftUI

struct PokemonInfoView: View {
    
    @StateObject private var vm: PokemonStatsModel
    
    let pokemonURL: String? = ""
    
    init(url: String) {
        _vm = StateObject(wrappedValue: PokemonStatsModel(url: url))
    }
    
    var body: some View {
        VStack {
            if vm.isLoadingImage {
                ProgressView()
            } else {
                Image(uiImage: (vm.image ?? UIImage(systemName: "questionmark.circle"))!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if vm.isLoading {
                ProgressView()
            } else {
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Text("Name:")
                            .bold()
                            .font(.title3)
                        Text(vm.stats?.name ?? "No name found")
                            .font(.title2)
                    }
                    HStack {
                        Text("Type:")
                            .bold()
                            .font(.title3)
                        Text("\(vm.stats?.types?[0].type?.name ?? "No type found")")
                            .font(.title2)
                    }
                    HStack {
                        Text("Weight:")
                            .bold()
                            .font(.title3)
                        Text("\(vm.stats?.weight ?? 0)")
                            .font(.title2)
                    }
                    HStack {
                        Text("Height:")
                            .bold()
                            .font(.title3)
                        Text("\(vm.stats?.height ?? 0)")
                            .font(.title2)
                    }
                }
                .navigationTitle(vm.stats?.name ?? "No name found")
            }
        }
        Spacer()
    }
}

struct PokemonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoView(url: "https://pokeapi.co/api/v2/pokemon/25/")
    }
}
