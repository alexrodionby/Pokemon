//
//  HomeView.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 2.09.22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = PokemonPageModel()
    
    var body: some View {
        VStack {
            List(vm.page?.results ?? [], id: \.url) { pokemon in
                NavigationLink(pokemon.name) {
                    PokemonInfoView(url: pokemon.url)
                }
            }
            .listStyle(.grouped)
            HStack {
                Spacer()
                Button {
                    vm.dataService.getPage(url: vm.page?.previous ?? "")
                } label: {
                    Text("Previous")
                }
                Spacer()
                Button {
                    vm.dataService.getPage(url: vm.page?.next ?? "")
                } label: {
                    Text("Next")
                }
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
