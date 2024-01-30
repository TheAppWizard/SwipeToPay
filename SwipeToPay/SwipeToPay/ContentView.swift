//
//  ContentView.swift
//  SwipeToPay
//
//  Created by Shreyas Vilaschandra Bhike on 29/01/24.

//  MARK: Instagram
//  TheAppWizard
//  MARK: theappwizard2408
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            KeypadSwipeView()
        }
    }
}

#Preview {
    ContentView()
}


struct KeypadSwipeView: View {
    @State private var sliderOffset: CGFloat = 0
    @State private var unlocked = false
    @State private var enteredText: String = ""
    

    let keypad: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["*", "0", "#"]
    ]

    var body: some View {
        ZStack {
            
           
            VStack {
                
                if(unlocked){
                    AnimationView(valueofMoney: enteredText)
                }
                
                if(!unlocked){
                    VStack{
                        VStack{
                            HStack {
                                Text(" Enter Amount ")
                                    .font(.system(size: 20))
                                    .background(.black)
                                .foregroundStyle(.white)
                                Spacer()
                            }
                                
                            TextField("0000000", text: $enteredText)
                                .font(.system(size: 45))
                                .background(.black)
                                .foregroundStyle(.white)
                        }.padding(10)
                            
                    
                            
                        Spacer().frame(height: 50)
                                   

                        VStack(spacing: 20) {
                            ForEach(keypad, id: \.self) { row in
                                HStack(spacing: 20) {
                                    ForEach(row, id: \.self) { key in
                                        Button(action: {
                                            handleKeypadButton(key: key)
                                        }) {
                                            
                                            ZStack{
                                                Circle()
                                                    .frame(width: 100, height: 100)
                                                    .background(.black)
                                                    .foregroundStyle(.white)
                                                    .opacity(0.08)
                                                
                                                Text(key)
                                                    .font(.system(size: 45))
                                                    .fontWeight(.regular)
                                                    .foregroundStyle(.white)
                                                    .cornerRadius(100)
                                                    
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
               
                
                Spacer()
               
        
                //Swipe Here
                ZStack {
                    Spacer()
                    
                    Text(unlocked ? "Sending..." : "> > >")
                        .font(.title2)
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .padding()
                    
                    ZStack(alignment: unlocked ? .trailing : .leading) {
                        RoundedRectangle(cornerRadius: 60)
                            .frame(width: 340, height: 75)
                            .foregroundColor(unlocked ? .gray.opacity(0.1) : .gray.opacity(0.1))
                        
                        Image(systemName: "indianrupeesign.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .offset(x: sliderOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        sliderOffset = max(min(value.translation.width, 280), 10)
                                    }
                                    .onEnded { value in
                                        if sliderOffset > 200 {
                                            unlocked = true
                                        } else {
                                            withAnimation {
                                                sliderOffset = 0
                                            }
                                        }
                                    }
                            )
                    }
                    
                    Spacer()
                }
                
                
                //Swipe Here
            }
            .padding()
            
            
            
           
        }
    }

    func handleKeypadButton(key: String) {
        if key.isEmpty {
            enteredText = String(enteredText.dropLast())
        } else {
            enteredText += key
        }
    }
}

//Loader Animation
struct AnimationView: View {
    @State private var dollarOffset = false
    @State private var dollarOpacity = false
    @State private var showLoader = false
    @State var valueofMoney = "0"
   

    var body: some View {
        ZStack {
            Image(systemName: "indianrupeesign.circle")
                .resizable()
                .foregroundStyle(.green)
                .frame(width: dollarOffset ? 300:  60, height: dollarOffset ? 300 :60)
                .offset(x: dollarOffset ? 0 : 130, y: dollarOffset ? 200 : 650)
                .opacity(dollarOpacity ? 0 : 1)
                .animation(.easeInOut,value: 0)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            dollarOffset.toggle()
                                }
                        }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation {
                            dollarOpacity.toggle()
                                }
                        }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                       withAnimation {
                          showLoader.toggle()
                               }
                       }
                

                }
            
            
            ZStack{
                HStack{
                    Text(valueofMoney)
                        .font(.system(size: 72))
                        .fontWeight(.regular)
                        .foregroundStyle(.white)
                    
                    
                    Text("₹")
                        .font(.system(size: 30))
                        .fontWeight(.regular)
                        .foregroundStyle(.white)
                        .offset(y:12)
                       
                    
                    
                }
                if(showLoader){
                    CircularLoaderView()
                }
            }
            
        }
    }
}


struct CircularLoaderView: View {
    @State private var border: CGFloat = 0.0
    @State private var isLoading: Bool = true
    @State private var showTick = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(Color.green)

            Circle()
                .trim(from: 0, to: border)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundStyle(Color.green)
                .rotationEffect(Angle(degrees: 360))
                .onAppear(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            showTick.toggle()
                        }
                    }
                }
                .onReceive(timer) { _ in
                    withAnimation {
                        border += 0.02
                        if border >= 1 {
                            isLoading = false
                            timer.upstream.connect().cancel()
                        }
                    }
                }
            
            
            
            
            if(showTick){
                TickMarkShape()
                    .trim(from: 0, to: 1)
                    .stroke(Color.green, lineWidth: 4)
                    .offset(x:-10)
            }
            
            if(showTick){
                ShowSent()
            }
            
        
            
            
                
            
        }.offset(x:0,y:215)
         .frame(width: 150,height: 150)
        .padding()
    }
}

//Tick Shape
struct TickMarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - 20, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + 20))
        path.addLine(to: CGPoint(x: rect.midX + 40, y: rect.midY - 20))
        return path
    }
}

struct ShowSent: View {
    @State private var showRectangle = false

    var body: some View {
        ZStack {
            if showRectangle {
                ZStack{
                    RoundedRectangle(cornerRadius: 60)
                        .frame(width: 340, height: 75)
                        .foregroundStyle(.black)
                    
                    RoundedRectangle(cornerRadius: 60)
                            .frame(width: 340, height: 75)
                            .foregroundStyle(.white)
                         
                    
                    Text("S E N T")
                        .font(.title2)
                        .foregroundColor(.black)
                    

                }
            } else {
               
            }
        }.offset(y: 325)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                showRectangle = true
            }
        }
    }
}






















