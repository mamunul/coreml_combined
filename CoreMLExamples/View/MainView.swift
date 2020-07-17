//
//  ContentView.swift
//  CoreMLExamples
//
//  Created by Mamunul Mazid on 16/7/20.
//  Copyright © 2020 Mamunul Mazid. All rights reserved.
//

import SwiftUI

let presenter = Presenter()

struct IntelligenceCategoryView: View {
    @ObservedObject var presenterObject: Presenter
    private let selectedBGColor = Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.2)
    private let nonSelectedBGColor = Color.clear
    private let dividerHeight: CGFloat = 10

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(presenterObject.intelligentArray, id: \.self) { intelligent in
                    HStack {
                        Text(intelligent.name)
                            .background(self.getBindingInstance(intelligent).wrappedValue.isSelected ? self.selectedBGColor : self.nonSelectedBGColor)
                        Divider().frame(height: self.dividerHeight)
                    }
                    .onTapGesture {
                        self.getBindingInstance(intelligent).wrappedValue.isSelected = true
                        self.presenterObject.update(intelligent: intelligent)
                    }
                }
            }
        }
    }

    func getBindingInstance(_ intelligent: Intelligent) -> Binding<Intelligent> {
        $presenterObject.intelligentArray[presenterObject.intelligentArray.firstIndex(of: intelligent)!]
    }
}

struct IntelligentConsoleView: View {
    var body: some View {
        VStack {
            HStack {
                Text("ms ")
                Text("MB ")
                Text(" ")
            }
            HStack {
                Text("Confidence: ")
                Text("Title: ")
            }
        }
    }
}

struct MainView: View {
    @State var image: Image?
    @State var showPicker = false
    @State var uiImage: UIImage?

    var presenterObject = presenter

    var body: some View {
        VStack {
            ZStack {
                ImagePreview(image: $image)

                Button(action: {
                    self.showPicker = true
                }) {
                    Text("Change Photo")
                }

                IntelligentConsoleView()
            }
            IntelligenceCategoryView(presenterObject: presenterObject)
        }.sheet(isPresented: $showPicker, onDismiss: {
            if self.uiImage != nil {
                self.image = Image(uiImage: self.uiImage!)
                self.presenterObject.update(image: self.uiImage!)
            }
        }) {
            ImagePickerView(uiImage: self.$uiImage)
        }
    }
}

struct ImagePreview: View {
    @Binding var image: Image?
    var body: some View {
        image?
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
