//
//  SlideOverCard.swift
//
//
//  Created by João Gabriel Pozzobon dos Santos on 30/10/20.
//

import SwiftUI

public struct SlideOverCardView<Content:View>: View {
    var isPresented: Binding<Bool>
    var position: Binding<CGPoint>
    var anchor: Binding<UnitPoint>
    var closeOnClickOutSide: Bool
    let onDismiss: (() -> Void)?
    
    var dragEnabled: Binding<Bool>
    var dragToDismiss: Binding<Bool>
    var displayExitButton: Binding<Bool>
    
    let content: Content
    
    public init(isPresented: Binding<Bool>, position: Binding<CGPoint>, anchor: Binding<UnitPoint>, closeOnClickOutSide: Bool, onDismiss: (() -> Void)? = nil, dragEnabled: Binding<Bool> = .constant(true), dragToDismiss: Binding<Bool> = .constant(true), displayExitButton: Binding<Bool> = .constant(true), content: @escaping () -> Content) {
        self.isPresented = isPresented
        self.position = position
        self.onDismiss = onDismiss
        self.dragEnabled = dragEnabled
        self.dragToDismiss = dragToDismiss
        self.displayExitButton = displayExitButton
        self.anchor = anchor
        self.closeOnClickOutSide = closeOnClickOutSide
        self.content = content()
    }
    
    @State var show = false
    
    @ViewBuilder
    public var body: some View {
        content
            .opacity(show ? 1 : 0)
            .scaleEffect(show ? 1 : 0, anchor: anchor.wrappedValue)
            .position(x: position.x.wrappedValue, y: position.y.wrappedValue)
            .animation(Animation.spring().speed(1.4))
//            .animation(Animation.spring(response: 0, dampingFraction: 2, blendDuration: 0.4).speed(0.6))
            .contentShape(Rectangle())
            .highPriorityGesture(
                TapGesture()
                    .onEnded {
                        if closeOnClickOutSide {
                            show = false
                            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                                isPresented.wrappedValue = false
                            }
                        }
                    }
            )
            .onAppear {
                show = true
            }
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    public func bottomSlideOverCard<Content:View>(isPresented: Binding<Bool>, closeOnClickOutSide: Bool = true, opacity: Double = 0.4, onDismiss: (() -> Void)? = nil, dragEnabled: Binding<Bool> = .constant(true), dragToDismiss: Binding<Bool> = .constant(true), displayExitButton: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                Color.shootBlack.opacity(isPresented.wrappedValue ? 0.1 : 0)
                //                    .animation(.linear(duration: 2))
//                    .animation(.spring(response: 0.35, dampingFraction: 1))
                //.animation(Animation.default.speed(2))
                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                    .onTapGesture {
                        if closeOnClickOutSide {
                            withAnimation {
                                resignFirstResponder()
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                
                VStack {
                    Spacer()
                    content()
                        .animation(.spring(response: 0.2, dampingFraction: 1))
                }.edgesIgnoringSafeArea(.all)
                .transition(AnyTransition.opacity.combined(with: .offset(x: 0, y: 200)).animation(Animation.default.speed(1.5)))
                .zIndex(2)
            }
        }
    }
    
    public func topSlideOverCard<Content:View>(isPresented: Binding<Bool>, closeOnClickOutSide: Bool = true, opacity: Double = 0.4, onDismiss: (() -> Void)? = nil, dragEnabled: Binding<Bool> = .constant(true), dragToDismiss: Binding<Bool> = .constant(true), displayExitButton: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                Color.black.opacity(isPresented.wrappedValue ? opacity : 0)
                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                    .onTapGesture {
                        if closeOnClickOutSide {
                           
                            withAnimation(.spring()) {
                                resignFirstResponder()
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                
                VStack {
                    content()
                        .animation(.spring(response: 0.35, dampingFraction: 1))
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
                .transition(AnyTransition.opacity.combined(with: .offset(x: 0, y: -1000)).animation(Animation.default.speed(2)))
                .zIndex(2)
            }
        }
    }
    
    public func centerSlideOverCard<Content:View>(isPresented: Binding<Bool>, closeOnClickOutSide: Bool = true, opacity: Double = 0.4, onDismiss: (() -> Void)? = nil, dragEnabled: Binding<Bool> = .constant(true), dragToDismiss: Binding<Bool> = .constant(true), displayExitButton: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack {
            self
            #if os(iOS)
                .blur(radius: isPresented.wrappedValue ? 10 : 0)
            #else
                .blur(radius: isPresented.wrappedValue ? 0.1 : 0)
            #endif
            
            if isPresented.wrappedValue {
                Color.black
                    .opacity(closeOnClickOutSide ? 0.01 : 0)
//                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                    .onTapGesture {
                        if closeOnClickOutSide {
                            withAnimation {
                                resignFirstResponder()
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                
                
                content()
                    .shadow(color: Color.gray.opacity(0.2), x: 0, y: 0, blur: 12)
                    .transition(.opacity.combined(with: .asymmetric(insertion: .scale, removal: .scale)))
                    .zIndex(2)
                /*
                VStack {
                    Spacer()
                    content()
//                        .padding(.horizontal, 26)
//                        .animation(Animation.spring(response: 0, dampingFraction: 2, blendDuration: 0.4).speed(0.2))
                        
                    Spacer()
                }.transition(.opacity.combined(with: .asymmetric(insertion: .scale(scale: 0.6), removal: .scale)))
//                .transition(AnyTransition.opacity.combined(with: .scale(scale: 0.8)).animation(Animation.default.speed(2)))
                */
            }
        }
    }
    
    public func dropSlideOverCard<Content:View>(isPresented: Binding<Bool>, closeOnClickOutSide: Bool = true, position: Binding<CGPoint>, anchor: Binding<UnitPoint>, opacity: Double = 0.4, onDismiss: (() -> Void)? = nil, dragEnabled: Binding<Bool> = .constant(true), dragToDismiss: Binding<Bool> = .constant(true), displayExitButton: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                Color.black.opacity(isPresented.wrappedValue ? 0.001 : 0)
                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        if closeOnClickOutSide {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                
                SlideOverCardView(isPresented: isPresented,
                                  position: position,
                                  anchor: anchor,
                                  closeOnClickOutSide: closeOnClickOutSide,
                                  onDismiss: onDismiss,
                                  dragEnabled: dragEnabled,
                                  dragToDismiss: dragToDismiss,
                                  displayExitButton: displayExitButton) {
                    content()
                }
            }
        }
    }
    
//    public func slideOverCard<Item:Identifiable, Content:View>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, dragEnabled: Binding<Bool> = .constant(true), dragToDismiss: Binding<Bool> = .constant(true), displayExitButton: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping (Item) -> Content) -> some View {
//        let binding = Binding(get: { item.wrappedValue != nil }, set: { if !$0 { item.wrappedValue = nil } })
//        return ZStack {
//            self
//            self.bottomSlideOverCard(isPresented: binding, onDismiss: onDismiss, dragEnabled: dragEnabled, dragToDismiss: dragToDismiss, displayExitButton: displayExitButton, content: { content(item.wrappedValue!) } )
//        }
//    }
    
    private func conditionalAspectRatio(_ apply: Bool, _ aspectRatio: CGFloat? = .none, contentMode: ContentMode) -> some View {
        Group {
            if apply {
                self.aspectRatio(aspectRatio, contentMode: contentMode)
            } else { self }
        }
    }
}


