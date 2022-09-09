//
//  HomeView.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 2.09.22.
//

// MARK: - Главный экран со списком покемонов

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = PokemonPageModel()
    @StateObject var nm = NetworkMonitor()
    
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if nm.isConnected {
                            HStack(spacing: 10) {
                                Text("WiFi ON")
                                    .foregroundColor(.green)
                                Image(systemName: "wifi")
                            }
                        }
                        if nm.isCellular {
                            HStack(spacing: 10) {
                                Text("Cellular ON")
                                    .foregroundColor(.yellow)
                                Image(systemName: "candybarphone")
                            }
                        }
                        if nm.isDisconnected {
                            HStack(spacing: 10) {
                                Text("NO Connection")
                                    .foregroundColor(.red)
                                Image(systemName: "antenna.radiowaves.left.and.right.slash")
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            nm.start()
        }
        .onDisappear {
            nm.stop()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
