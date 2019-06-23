//
//  StoryboardWriter.swift
//  Basic
//
//  Created by Rob Saunders on 6/4/19.
//

import Foundation

let SCREEN_HEIGHT: Float = 716
let SCREEN_WIDTH: Float = 414
let INPUT_FIELD_HEIGHT: Float = 30

private func whiteColor(_ key: String) -> XMLElement {
	return makeElement("color", attributes: [
		("key", key),
		("white", "1"),
		("alpha", "1"),
		("colorSpace", "custom"),
		("customColorSpace", "genericGamma22GrayColorSpace")
	])
}

func stackView(id: String = StoryboardUID.popLast()!, height: Float, children: [XMLElement]) -> XMLElement {
	return makeElement("stackView", attributes: [
			("id", id),
			("contentMode", "TopLeft"),
			("distribution", "equalSpacing"),
			("axis", "vertical"),
			("spacing", "10")
		], children: [
		rectElement(x: 10.0, y: 20.0, w: SCREEN_WIDTH - 20, h: height),
		makeElement("subviews", children: children)
	])
}

func textInputGroup(id: String = StoryboardUID.popLast()!, name: String) -> XMLElement {
	return textField(id: id, placeholder: name)
}

func labelElement(id: String = StoryboardUID.popLast()!, text: String) -> XMLElement {
	return makeElement("label", attributes: [
		("id", id),
		("text", text)
		], children: [
			whiteColor("backgroundColor"),
			rectElement(x: 0.0, y: 0.0, w: 390, h: INPUT_FIELD_HEIGHT)
		])
}

func textField(id: String = StoryboardUID.popLast()!, placeholder: String) -> XMLElement {
	return makeElement("textField", attributes: [
			("id", id),
			("placeholder", placeholder),
			("borderStyle", "roundedRect")
		], children: [
		rectElement(x: 0.0, y: 0.0, w: 390, h: INPUT_FIELD_HEIGHT),
		makeElement("textInputTraits", attributes: [
			("key", "textInputTraits")
		])
	])
}

func rectElement(x: Float, y: Float, w: Float, h: Float) -> XMLElement {
	return makeElement("rect", attributes: [
		("key", "frame"),
		("x", "\(x)"),
		("y", "\(y)"),
		("width", "\(w)"),
		("height", "\(h)"),
	])
}

func makeElement(_ name: String, attributes: [(String, String)] = [], children: [XMLElement] = []) -> XMLElement {
	let element = XMLElement(name: name)
	for (name, value) in attributes {
		element.addAttribute(XMLNode.attribute(withName: name, stringValue: value) as! XMLNode)
	}
	for child in children {
		element.addChild(child)
	}
	return element
}

func scenesElement(children: [XMLElement] = []) -> XMLElement {
	let root = makeElement("scenes", children: children)
	return root
}

func deviceIdElement() -> XMLElement {
	let root = makeElement("device", attributes: [
		("id", "retina5_5"),
		("orientation", "portrait")
		], children: [
			makeElement("adaptation", attributes: [("id", "fullscreen")])
		])
	return root
}

func viewControllerElement(id: String = StoryboardUID.popLast()!, storyboardIdentifier: String, title: String, children: [XMLElement] = []) -> XMLElement {
	return makeElement("viewController", attributes: [
		("id", id),
		("storyboardIdentifier", storyboardIdentifier),
		("sceneMemberID", "viewController"), // ?
		("title", title) // optional
		], children: children)
}

func viewElement(key: String, id: String = StoryboardUID.popLast()!, children: [XMLElement] = []) -> XMLElement {
	return makeElement("view", attributes: [
		("contentMode", "scaleToFill"),
		("key", key),
		("id", id)
		], children: [
			rectElement(x: 0.0, y: 0.0, w: 414, h: 736),
			whiteColor("backgroundColor"),
			makeElement("subviews", children: children)
		])
}

func sceneElement(sceneID: String, children: [XMLElement] = []) -> XMLElement {
	var children = children

	children.append(makeElement("placeholder", attributes: [
		("placeholderIdentifier", "IBFirstResponder"),
		("id", "Vym-lb-ZTs"),
		("userLabel", "First Responder"),
		("sceneMemberID", "firstResponder")
	]))

	return makeElement("scene", attributes: [("sceneID", sceneID)],
					   children: [makeElement("objects", children: children)])
}

func rootElement(initialViewController: String) -> XMLElement {
	return makeElement("document", attributes: [
		("type", "com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB"),
		("version", "3.0"),
		("targetRuntime", "iOS.CocoaTouch"),
		("toolsVersion", "14490.70"),
		("targetRuntime", "iOS.CocoaTouch"),
		("propertyAccessControl", "none"),
		("useAutolayout", "YES"),
		("useTraitCollections", "YES"),
		("useSafeAreas", "YES"),
		("colorMatched", "YES"),
		("initialViewController", initialViewController),
	])
}

class StoryboardWriter  {
	var document: XMLDocument

	init(initialVC: String, children: [XMLElement]) {
		let root = rootElement(initialViewController: initialVC)

		for child in children {
			root.addChild(child)
		}

		self.document = XMLDocument(rootElement: root)
		self.document.version = "1.0"
		self.document.characterEncoding = "UTF-8"
	}

	func toString() -> String {
		return self.document.xmlString(options: [.documentIncludeContentTypeDeclaration, .documentTidyXML, .nodePrettyPrint])
	}
}

func createStoryboardFrame(content: [XMLElement]) -> String {
	return StoryboardWriter(initialVC: "initialVC", children: [
		deviceIdElement(),
		scenesElement(children: [
			sceneElement(sceneID: "PxX-uQ-w9m", children: [
					viewControllerElement(id: "initialVC", storyboardIdentifier: "Auth", title: "Sign in/up", children: content)
				])
			])
		]).toString()
}

func inputGroup(title: String, fields: [String]) -> XMLElement {
	var elements:[XMLElement] = [labelElement(text: title)]

	for field in fields {
		elements.append(labelElement(text: field))
		elements.append(textField(placeholder: field))
	}

	return stackView(
		height: INPUT_FIELD_HEIGHT * Float(elements.count + 1),
		children: elements)
}
