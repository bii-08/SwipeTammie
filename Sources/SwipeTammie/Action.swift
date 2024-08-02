//
//  File.swift
//  
//
//  Created by LUU THANH TAM on 2024/08/01.
//

import SwiftUI

/// Representation of a swipe action
///
/// The ``Action`` struct models a swipe action that can be performed in a swipeable view.
/// It includes properties for the title, icon, background color, foreground color, corner radius, and the action to be executed.
///
/// - Parameters:
///   - title: The title of the action, displayed as text.
///   - icon: The name of the system icon representing the action.
///   - bgColor: The background color of the action button.
///   - fgColor: The foreground color of the action button.
///   - cornerRadius: The corner radius of the action button. Default is 0.
///   - action: The closure to be executed when the action is triggered.
///
/// - Note:
/// The `id` property is a unique identifier for each action instance, generated using `UUID`.
public struct Action: Identifiable {
    /// The `id` property is a unique identifier for each action instance, generated using `UUID`.
    public let id = UUID().uuidString
    /// The title of the action, displayed as text.
    public let title: String
    /// The name of the system icon representing the action.
    public let icon: String
    /// The background color of the action button.
    public let bgColor: Color
    /// The foreground color of the action button.
    public let fgColor: Color
    /// The corner radius of the action button. Default is 0.
    public let cornerRadius: CGFloat
    /// The closure to be executed when the action is triggered.
    public let action: () -> Void?
    
    /// Initializes a new ``Action`` with the provided parameters.
        ///
        /// - Parameters:
        ///   - title: The title of the action.
        ///   - icon: The name of the system icon representing the action.
        ///   - bgColor: The background color of the action button.
        ///   - fgColor: The foreground color of the action button.
        ///   - cornerRadius: The corner radius of the action button. Default is 0.
        ///   - action: The closure to be executed when the action is triggered.
    public init(title: String, icon: String, bgColor: Color, fgColor: Color, cornerRadius: CGFloat = 0, action: @escaping () -> Void?) {
        self.title = title
        self.icon = icon
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
}
