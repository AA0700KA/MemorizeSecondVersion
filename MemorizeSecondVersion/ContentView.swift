//
//  ContentView.swift
//  MemorizeSecondVersion
//
//  Created by Andrew Bondarenko on 05.01.2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel : EmodjiMemoryGame
    

    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        let cardsPair = viewModel.cards.chunk(size: 3)

        
        VStack {
            Text(viewModel.text)
            
            
        GeometryReader { geometry in
            LazyVGrid(columns: layout, spacing: geometry.size.height/CGFloat(cardsPair.count)) {

            ForEach(viewModel.cards) { card in

                CardView(card: card, height: geometry.size.height/CGFloat(cardsPair.count), width: geometry.size.width/3).onTapGesture {

                    withAnimation(.linear(duration: 0.75)) {
                       viewModel.chose(card: card)
                    }

                    }

                }
                
        }

        }.padding(EdgeInsets(top: 0,leading: 0, bottom: 25, trailing: 0))
        
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.createNewGame()
                }
            }, label: {
                Text("New Game")
            }).offset(CGSize(width: 0, height: 30))
            
        }

        .foregroundColor(Color.init(
                            red: Double.init(viewModel.color.rawValue.split(separator: " ")[1]) ?? 1.0,
                            green: Double.init(viewModel.color.rawValue.split(separator: " ")[2]) ?? 1.0,
                            blue: Double.init(viewModel.color.rawValue.split(separator: " ")[3]) ?? 1.0)
        )
        .padding()
        .font(Font.largeTitle)
        .background(Color.white)
        
        

    }
    
    
}
    




struct CardView : View {
    
    var card : MemorizeGame<String>.Card
    var height : CGFloat
    var width : CGFloat
    
    @State private var animatingBonusRemaining : Double = 0
    
    private func startBonusTimeAnimation() {
        animatingBonusRemaining = animatingBonusRemaining + 1
        
//        if animatingBonusRemaining > 36 {
//            animatingBonusRemaining = 0
//        }
    
    }
    
    var body: some View {
        
        VStack {
            GeometryReader { geometry in
                
               
                    if card.isFaceUp || !card.isMatched {
                    
                        ZStack {
                       
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(animatingBonusRemaining*10-90))
                                .padding(5).opacity(0.4)
                                .onAppear{
                                    startBonusTimeAnimation()
                                }.animation(Animation.default.repeatForever())
                                .transition(.scale)
                            
                            Text(card.content).font(
                                Font.system(size: min(width, height) * 0.65))
                                .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                                .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
                       
                    
                        }.cardify(isFaceUp: card.isFaceUp)
                        .frame( width:width, height:height)
                        .transition(.scale)
                        
                    }
            }
                
              
                
                
                
                
            }
        
            
        
        
        
    }
    
}




