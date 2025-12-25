//
//  ContentView.swift
//  CanvasNudgeView
//
//  Created by Meggi on 21/11/25.
//

import SwiftUI
// enum for the directions
enum Direction{
    case left, right, up, down
}

struct ContentView: View {
    
    // move the elements
    @State private var position: CGPoint = CGPoint(x: 150, y: 150)
    // continue movement timmer
    @State private var timer: Timer? = nil
    
    
    // variable declaraion
    let canvasSize: CGSize = CGSize(width: 300, height: 500)
    let elementSize: CGSize = CGSize(width: 120, height: 40)
    
    let nudgeAmount: CGFloat = 2
    let continuousSpeed: CGFloat = 2
    
    var body: some View {
        
        // gray box
        VStack(spacing: 20) {
            ZStack{
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: canvasSize.width, height: canvasSize.height)
                    .cornerRadius(10)
                
                Text("Editable Element")
                    .frame(width: elementSize.width + 40, height: elementSize.height)
                    .background(Color.yellow)
                    .cornerRadius(8)
                    .position(position)
                    .animation(.linear(duration: 0.05), value: position)
            }
            // arrow sign delcataion
            VStack (spacing:12){
                Button(action: { singleTap(.up) }) {
                    Image(systemName: "arrow.up.circle.fill").font(.largeTitle)
                }
                .gesture(longPress(direction: .up))
                HStack(spacing: 40) {
                    Button(action: { singleTap(.left) }) {
                        Image(systemName: "arrow.left.circle.fill").font(.largeTitle)
                    }
                    .gesture(longPress(direction: .left))
                    
                    Button(action: { singleTap(.right) }) {
                        Image(systemName: "arrow.right.circle.fill").font(.largeTitle)
                    }
                    .gesture(longPress(direction: .right))
                }
                Button(action: { singleTap(.down) }) {
                    Image(systemName: "arrow.down.circle.fill").font(.largeTitle)
                }
                .gesture(longPress(direction: .down))
            }
        }
    }
    // single tap direction
    func singleTap(_ direction: Direction){
        var newPos = position
        
        switch direction {
        case .left:  newPos.x -= nudgeAmount
        case .right: newPos.x += nudgeAmount
        case .up:    newPos.y -= nudgeAmount
        case .down:  newPos.y += nudgeAmount
        }
        
        position = enforceBounds(newPos)
    }
    
    // Not go to the out of boundarys
    func enforceBounds(_ point: CGPoint) -> CGPoint {
        let halfW = elementSize.width / 2
        let halfH = elementSize.height / 2
        
        let minX = halfW
        let maxX = canvasSize.width - halfW
        
        let minY = halfH
        let maxY = canvasSize.height - halfH
        
        return CGPoint(
            x: min(max(point.x, minX), maxX),
            y: min(max(point.y, minY), maxY)
        )
    }
    
    // Long press event
    func longPress(direction: Direction) -> some Gesture {
        LongPressGesture(minimumDuration: 0.2)
            .onEnded { _ in
                startTimer(direction)
            }
            .simultaneously(with:
                                DragGesture(minimumDistance: 0)
                .onEnded { _ in stopTimer() }
            )
    }
    func startTimer(_ direction: Direction) {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            var newPos = position
            
            switch direction {
            case .left:  newPos.x -= continuousSpeed
            case .right: newPos.x += continuousSpeed
            case .up:    newPos.y -= continuousSpeed
            case .down:  newPos.y += continuousSpeed
            }
            
            position = enforceBounds(newPos)
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    ContentView()
}
