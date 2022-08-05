//
//  Tool.swift
//  AnimationToolbar
//
//  Created by Гермек Александр Георгиевич on 05.08.2022.
//

import SwiftUI

/// Tool
struct Tool: Identifiable {
	var id: String = UUID().uuidString
	var icon: String
	var name: String
	var color: Color
	var toolPosition: CGRect = .zero
}
