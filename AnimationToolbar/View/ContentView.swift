//
//  ContentView.swift
//  AnimationToolbar
//
//  Created by Гермек Александр Георгиевич on 05.08.2022.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationStack {
			Home()
				.navigationTitle("Toolbar Animation")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
