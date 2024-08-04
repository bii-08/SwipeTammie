// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

/// A custom view that enables swipe actions on a content view.
///
/// `SwipeTammie` allows you to add swipeable actions to a view, with customizable actions on both left and right swipe directions.
/// You can specify the content view, left and right actions, and an optional frame height.
///
/// - Parameters:
///   - content: A closure that returns the content view to be displayed.
///   - leftActions: An optional array of ``Action`` representing the actions available when swiping to the right.
///   - rightActions: An array of ``Action`` representing the actions available when swiping to the left.
///   - frameHeight: An optional CGFloat value specifying the minimum height of the frame. Defaults to 90.
///
/// Example usage:
/// ```swift
/// SwipeTammie(content: {
///     Text("Swipe me!")
///         .frame(maxWidth: .infinity, maxHeight: .infinity)
///         .background(Color.blue.opacity(0.5))
///         .cornerRadius(10)
/// }, leftActions: [
///     Action(title: "Edit", icon: "pencil", bgColor: .yellow, action: { /* Edit action */ })
/// ], rightActions: [
///     Action(title: "Delete", icon: "trash", bgColor: .red, action: { /* Delete action */ })
/// ], frameHeight: 100)
/// ```
public struct SwipeTammie<Content: View>: View {
    @GestureState var isDragging = false
    @State var dragOffset: CGFloat = 0
    /// An optional array of `Action` representing the actions available when swiping to the right.
    public var leftActions: [Action]?
    /// An array of `Action` representing the actions available when swiping to the left.
    public var rightActions: [Action]
    /// A closure that returns the content view.
    public let content: Content
    /// An optional CGFloat value specifying the minimum height of the frame. Defaults to 90.
    public let frameHeight: CGFloat
    
    /// Initializes a new `SwipeTammie` view with the specified content and actions.
        ///
        /// - Parameters:
        ///   - content: A closure that returns the content view.
        ///   - leftActions: An optional array of actions for right swipe.
        ///   - rightActions: An array of actions for left swipe.
        ///   - frameHeight: An optional CGFloat value specifying the minimum height of the frame. Defaults to 90.
    public init(@ViewBuilder content: () -> Content, leftActions: [Action]?, rightActions: [Action], frameHeight: CGFloat = 90) {
        self.content = content()
        self.leftActions = leftActions
        self.rightActions = rightActions
        self.frameHeight = frameHeight
    }
    public var body: some View {
        ZStack {
            // Action views
            if dragOffset < 0 {
                HStack {
                    Spacer()
                    makeActionsView(actions: rightActions)
                        .frame(width: abs(dragOffset + 40))
                        .padding(.horizontal)
                }
            } else if dragOffset > 0 {
                HStack {
                    makeActionsView(actions: leftActions ?? [])
                        .frame(width: abs(dragOffset - 10))
                    Spacer()
                }
            }
            // Main content
            content
                .offset(x: dragOffset)
                .gesture(DragGesture()
                    .updating($isDragging) { value, state, _ in
                        state = true
                        DispatchQueue.main.async {
                            onChange(value: value)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            onEnd(value: value)
                        }
                    }
                )
        }
        .onDisappear {
            dragOffset = 0
        }
        .padding(.horizontal)
        .frame(minHeight: frameHeight)
    }
    
    // MARK: - FUNCTIONS
    
    /// Updates the `dragOffset` based on the gesture's translation.
    ///
    /// - Parameter value: The current value of the drag gesture.
    private func onChange(value: DragGesture.Value) {
        // Update dragOffset based on the gesture's translation
        if value.translation.width < 0 && isDragging {
            dragOffset = value.translation.width
        } else if value.translation.width > 0 && isDragging {
            dragOffset = value.translation.width
        }
    }
    
    /// Handles the end of the drag gesture, determining the final state of the swipe.
    ///
    /// - Parameter value: The final value of the drag gesture.
    private func onEnd(value: DragGesture.Value) {
        // Handle the end of the gesture
        if value.translation.width < 0 {
            if value.translation.width <= -50 {
                withAnimation {
                    dragOffset = CGFloat(min(4, rightActions.count)) * -80
                }
            } else {
                withAnimation {
                    dragOffset = 0
                }
            }
        } else {
            if value.translation.width > 50 {
                withAnimation {
                    dragOffset = CGFloat(min(4, leftActions?.count ?? 0)) * 80
                }
            } else {
                withAnimation {
                    dragOffset = 0
                }
            }
        }
    }
    
    // MARK: - ACTION VIEW
    @ViewBuilder
    private func makeActionsView(actions: [Action]) -> some View {
        HStack(spacing: 8) {
            ForEach(actions) { action in
                ZStack {
                    Rectangle()
                        .fill(action.bgColor)
                        .cornerRadius(action.cornerRadius)
                    Button {
                        action.action()
                    } label: {
                        VStack {
                            Image(systemName: action.icon)
                                .foregroundColor(action.fgColor)
                                .font(.system(size: 20))
                                .padding(.bottom, 8)
                            Text(action.title)
                                .foregroundColor(action.fgColor)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .frame(width: 70)
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct SwipebleView_Previews: PreviewProvider {
     static var previews: some View {
        
        let items = ["View 1", "View 2", "View 3"]
      
        VStack {
            ScrollView {
                ForEach(items.indices, id:\.self) { index in
                    SwipeTammie(content: {
                        Text(items[index])
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.blue.opacity(0.5))
                            .cornerRadius(10)
                    },
                    leftActions: [
                        Action(title: "Share", icon: "square.and.arrow.up", bgColor: .blue, fgColor: .white, cornerRadius: 10, action: { })
                    ],
                    rightActions: [
                         Action(title: "Edit", icon: "pencil", bgColor: .orange, fgColor: .white, cornerRadius: 10, action: {}),
                         Action(title: "Delete", icon: "trash", bgColor: .red, fgColor: .white, cornerRadius: 10, action: {})
                    ])
                }
            }
            Spacer()
        }
    }
}
