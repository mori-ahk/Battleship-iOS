//
//  ContentView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-18.
//

import SwiftUI

// An identifiable container for a path
//struct PathContainer: Identifiable {
//    let id: UUID
//    let path: Path
//}

struct ContentView: View {
//    @State var paths: [PathContainer] = []
//    @State var currentDraggingId = UUID()
//    
//    var body: some View {
//        ZStack {
//            // Background Color for the drawable area
//            Color.blue
//            
//            ForEach(paths) { container in
//                // draw and set the foreground color of the paths to red
//                container.path
//                    .fill(Color.red)
//            }
//        }
//        .gesture(drawGesture)
//    }
//    
//    
//    var drawGesture: some Gesture {
//        DragGesture(minimumDistance: 0)
//            .onChanged { value in
//                // The point that the gesture started from
//                let start = value.startLocation
//                // The point that the gesture ended to
//                let end = value.location
//                // the properties of the rectangle to be drawn
//                let rectangle: CGRect = .init(origin: end,
//                                              size: .init(width: start.x - end.x,
//                                                          height: 30))
//                // create a path for the rectangle
//                let path: Path = .init { path in
//                    path.addRect(rectangle)
//                }
//                
//                // remove the previous rectangle that was drawen in current
//                // process of drawing
//                paths.removeAll { $0.id == currentDraggingId }
//                // append the new rectangle
//                paths.append(.init(id: currentDraggingId, path: path))
//            }
//            .onEnded { _ in
//                // renew the dragging id so the app know that the next
//                // drag gesture is drawing a completely new rectangle,
//                // and is not continuing the drawing of the last rectangle
//                currentDraggingId = .init()
//            }
//    }
    let gridSize: Int = 3
    @GestureState private var gestureLocation: CGPoint?
    var body: some View {
        Grid {
            ForEach(0 ..< gridSize, id: \.self) { row in
                GridRow {
                    ForEach(0 ..< gridSize, id: \.self) { column in
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 50, height: 50)
                            .background {
                                if column == 0 {
                                    UnevenRoundedRectangle(
                                        cornerRadii: RectangleCornerRadii(topLeading: 16, bottomLeading: 16, bottomTrailing: .zero, topTrailing: .zero),
                                        style: .continuous
                                    )
                                    .fill(.red)
                                    .offset(x: 4, y: .zero)
                                } else {
                                    UnevenRoundedRectangle(
                                        cornerRadii: RectangleCornerRadii(topLeading: .zero, bottomLeading: .zero, bottomTrailing: 16, topTrailing: 16),
                                        style: .continuous
                                    )
                                    .fill(.red)
                                    .offset(x: -4, y: .zero)
                                }
                                
                            }
                            .overlay {
                                GeometryReader { proxy in
                                    if let gestureLocation {
                                        if proxy.frame(
                                            in: .named("grid")
                                        ).contains(gestureLocation) {
                                            Circle().fill(.red)
                                        }
                                    }
                                }
                            }
                    }
                }
            }
        }
        .coordinateSpace(name: "grid")
        .gesture(
            DragGesture(
                minimumDistance: .zero,
                coordinateSpace: .named("grid")
            )
            .updating($gestureLocation) { value, state, transaction in
                state = value.location
            }
                .onEnded { _ in
                    print("ended")
                }
        )
        .onChange(of: gestureLocation) { newValue in
           print(newValue)
        }
    }
}

#Preview {
    ContentView()
}
