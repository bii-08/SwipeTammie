# Integrating SwipeTammie to your view

SwipeTammie is a custom view that enables swipe actions on a content view.

## Overview

Implement swipeable actions to a view, with customizable actions on both left and right swipe directions.

## Usage
To use SwipeTammie, you need to provide the content view, left and right actions, and an optional frame height. 

```swift
SwipeTammie(content: {
    // pass in your content view
    Text("Swipe me!")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
}, leftActions: [
    Action(title: "Edit", icon: "pencil", bgColor: .yellow, action: { /* Edit action */ })
], rightActions: [
    Action(title: "Delete", icon: "trash", bgColor: .red, action: { /* Delete action */ })
], frameHeight: 100)
```

