//
//  Home.swift
//  AnimationToolbar
//
//  Created by Гермек Александр Георгиевич on 05.08.2022.
//

import SwiftUI

struct Home: View {
	// MARK: - Properties
	/// Samples
	@State var tools: [Tool] = [
		.init(icon: "scribble.variable", name: "Scribble", color: .purple),
		.init(icon: "lasso", name: "Lasso", color: .green),
		.init(icon: "plus.bubble", name: "Comment", color: .blue),
		.init(icon: "bubbles.and.sparkles.fill", name: "Enhance", color: .orange),
		.init(icon: "paintbrush.pointed.fill", name: "Picker", color: .pink),
		.init(icon: "rotate.3d", name: "Rotate", color: .indigo),
		.init(icon: "gear.badge.questionmark", name: "Settings", color: .yellow)
	]

	/// Animation Property
	@State var activeTool: Tool?

	/// Started position
	@State var startedToolPosition: CGRect = .zero

	var body: some View {
		VStack {
			/// Toolbar View
			VStack(alignment: .leading, spacing: 12) {
				ForEach($tools) { $tool in
					/// Tool View
					ToolView(tool: $tool)
				}
			}
			.padding(.horizontal, 10)
			.padding(.vertical, 12)
			.background {
				RoundedRectangle(cornerRadius: 10, style: .continuous)
					.fill(.white.shadow(
						.drop(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
					).shadow(
						.drop(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
					))
				/// Image Size = 45  + Horizonatal padding = 20
				/// Limiting frame
					.frame(width: 65)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			/// Coordinate Space for dragging
			.coordinateSpace(name: "AREA")
			/// Gestures
			.gesture(
				DragGesture(minimumDistance: 0)
					.onChanged({ value in
						/// Current Drag Location
						guard let firstTool = tools.first else { return }
						if startedToolPosition == .zero {
							startedToolPosition = firstTool.toolPosition
						}
						let location = CGPoint(x: startedToolPosition.midX, y: value.location.y)

						/// Checking if the location lies on any of the tools
						if let index = tools.firstIndex(where: { tool in
							tool.toolPosition.contains(location)
						}), activeTool?.id != tools[index].id {
							/// Animating active tool
//							withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
//								activeTool = tools[index]
//							}
							withAnimation(.interpolatingSpring(stiffness: 230, damping: 20)) {
								activeTool = tools[index]
							}
						}
					})
					.onEnded({ _ in
						withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
							activeTool = nil
							startedToolPosition = .zero
						}
					})
			)
		}
		.padding(15)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.background(.green)
	}

	@ViewBuilder
	func ToolView(tool: Binding<Tool>) -> some View {
		let isHighlitedTool = activeTool?.id == tool.wrappedValue.id

		HStack(spacing: 5) {
			Image(systemName: tool.wrappedValue.icon)
				.font(.title2)
				.foregroundColor(.white)
				.frame(width: 45, height: 45)
				.padding(.leading, isHighlitedTool ? 5 : 0)
			/// Getting image location using geometry proxy and preference key
				.background {
					GeometryReader { proxy in
						let frame = proxy.frame(in: .named("AREA"))
						Color.clear
							.preference(key: RectKey.self, value: frame)
							.onPreferenceChange(RectKey.self) { rect in
								tool.wrappedValue.toolPosition = rect
							}
					}
				}

			if isHighlitedTool {
				Text(tool.wrappedValue.name)
					.padding(.trailing, 16)
					.foregroundColor(.white)
			}

		}
		.background {
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.fill(tool.wrappedValue.color.gradient)
		}
		.offset(x: isHighlitedTool ? 60 : 0)
	}
}

struct Home_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

/// Position Preference Key
struct RectKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}
