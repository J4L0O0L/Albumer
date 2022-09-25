//
//  HomeView.swift
//  Albumer
//
//  Created by Marjan Khodadad on 9/21/22.
//

import SwiftUI
import WaterfallGrid

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showDetail: Bool = false
    @State private var selectedMedia: SharedMediaModel? = nil
    @State private var columnsCount: Int = 2
    
    @State private var imgUrl: String = ""
    var body: some View {
        
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                homeHeader
                allImagesGrid.transition(.move(edge: .leading))
                Spacer(minLength: 0)
            }
            
        }
        .overlay(ImageViewer(imageURL: self.selectedMedia?.thumbnailURL ?? "", viewerShown: self.$showDetail))
 
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}


extension HomeView {
    
    private func segue(media: SharedMediaModel) {
        selectedMedia = media
        imgUrl = media.thumbnailURL ?? ""
        showDetail.toggle()
    }
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: columnsCount == 3 ? "rectangle.grid.2x2" : "square.grid.3x2")
                .animation(.none)
                .onTapGesture {
                    columnsCount = columnsCount == 3 ? 2 : 3
                }
                .background(
                    CircleButtonAnimationView(animate: $showDetail)
                )
            Spacer()
            Image("KiliaroTypo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.green)
                .scaledToFit()
                .frame(width: 60)
            Spacer()
            CircleButtonView(iconName: "goforward")
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0.0))
                .animation(vm.isLoading ? Animation.linear(duration: 2.0)
                            .repeatForever(autoreverses: false) : .default)
                .onTapGesture {
                    vm.reloadData()
                }
        }
        .padding(.horizontal)
    }
    
    private var allImagesGrid: some View {
        
        ScrollView {
            WaterfallGrid(vm.allMedia) { media in
                SharedImageView(coin: media)
                    .onTapGesture {
                        segue(media: media)
                    }
            }
            .gridStyle(
                columns: columnsCount
            )
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        
        
    }
}

