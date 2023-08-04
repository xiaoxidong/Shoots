import SwiftUI

/**
 TagField is an input textfield for SwiftUI that can contain tag data

 # Example #
 ```
 var tags:[String] = []

 TagField(tags: $tags, placeholder: "Add Tags..", prefix: "#")
 ```
 */
public struct TagField: View {
    @Binding public var tags: [String]

    @FocusState var focused: Bool
    @State private var newTag: String = ""
    @State var color: Color = .init(.sRGB, red: 50 / 255, green: 200 / 255, blue: 165 / 255)

    public var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tags, id: \.self) { tag in
                            HStack {
                                Text(tag)
                                    .fixedSize()
                                    .foregroundColor(color.opacity(0.8))
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .padding([.leading], 10)
                                    .padding(.vertical, 5)
                                Button(action: {
                                    withAnimation {
                                        tags.removeAll { $0 == tag }
                                    }
                                    newTag = ""
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(color.opacity(0.8))
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .padding([.trailing], 10)
                                }
                            }.background(color.opacity(0.1).cornerRadius(.infinity))
                        }
                        TextField("输入标签", text: $newTag, onEditingChanged: { _ in
//                            appendNewTag()
                        }, onCommit: {
                            appendNewTag()
                        })
                        .focused($focused)
                        .onChange(of: newTag) { change in
                            if change.isContainSpaceAndNewlines() {
                                appendNewTag()
                            }
                            withAnimation(Animation.easeOut(duration: 0).delay(1)) {
                                scrollView.scrollTo("TextField", anchor: .trailing)
                            }
                        }
                        .onChange(of: tags, perform: { _ in
                            newTag = ""
                        })
                        .fixedSize()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .accentColor(color)
                        .id("TextField")
                        .padding(.trailing)
                    }.padding()
                }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(color, lineWidth: style == .RoundedBorder ? 0.75 : 0)
//                )
            }
//            .background(
//                Color.gray.opacity(style == .Modern ? 0.07 : 0)
//            )
//            if style == .Modern {
//                color.frame(height: 2).cornerRadius(1)
//            }
        }
    }

    func appendNewTag() {
        var tag = newTag
        if !isBlank(tag: tag) {
            if tag.last == " " {
                tag.removeLast()
                if !isOverlap(tag: tag) {
                    withAnimation {
                        tags.append(tag)
                    }
                }
            } else {
                if !isOverlap(tag: tag) {
                    withAnimation {
                        tags.append(tag)
                    }
                }
            }
        }
        newTag = ""
        focused = true
    }

    func isOverlap(tag: String) -> Bool {
        if tags.contains(tag) {
            return true
        } else {
            return false
        }
    }

    func isBlank(tag: String) -> Bool {
        let tmp = tag.trimmingCharacters(in: .whitespaces)
        if tmp == "" {
            return true
        } else {
            return false
        }
    }

//    public init(tags: Binding<[String]>, placeholder: String) {
//        _tags = tags
//        self.placeholder = placeholder
//    }
//
//    public init(tags: Binding<[String]>, placeholder: String, prefix: String) {
//        _tags = tags
//        self.placeholder = placeholder
//        self.prefix = prefix
//    }
//
//    public init(tags: Binding<[String]>, placeholder: String, prefix: String, color: Color, style: TagFieldStyle, lowercase: Bool) {
//        _tags = tags
//        self.prefix = prefix
//        self.placeholder = placeholder
//        _color = .init(initialValue: color)
//        self.style = style
//        self.lowercase = lowercase
//    }
}

// public extension TagField {
//    func accentColor(_ color: Color) -> TagField {
//        TagField(tags: $tags,
//                 placeholder: placeholder, prefix: prefix,
//                 color: color,
//                 style: style,
//                 lowercase: lowercase)
//    }
//
//    func styled(_ style: TagFieldStyle) -> TagField {
//        TagField(tags: $tags,
//                 placeholder: placeholder, prefix: prefix,
//                 color: color,
//                 style: style,
//                 lowercase: lowercase)
//    }
//
//    func lowercase(_ bool: Bool) -> TagField {
//        TagField(tags: $tags,
//                 placeholder: placeholder,
//                 prefix: prefix,
//                 color: color,
//                 style: style,
//                 lowercase: bool)
//    }
// }
