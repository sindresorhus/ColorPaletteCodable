@testable import ColorPaletteCodable
import XCTest

import Foundation

class GradientTests: XCTestCase {

	func testBasic() throws {
		let gradient = PAL.Gradient(
			name: "first",
			colors: [
				try PAL.Color(rgbHexString: "#FFFFFFFF"),
				try PAL.Color(rgbHexString: "#444444FF"),
				try PAL.Color(rgbHexString: "#000000FF")
			]
		)

		XCTAssertEqual("first", gradient.name)
		XCTAssertEqual(3, gradient.stops.count)
		XCTAssertEqual(0, gradient.stops[0].position)
		XCTAssertEqual("#ffffffff", gradient.stops[0].color.hexRGBA)
		XCTAssertEqual(0.5, gradient.stops[1].position)
		XCTAssertEqual("#444444ff", gradient.stops[1].color.hexRGBA)
		XCTAssertEqual(1.0, gradient.stops[2].position)
		XCTAssertEqual("#000000ff", gradient.stops[2].color.hexRGBA)

		let g1 = try JSONEncoder().encode(gradient)
		let gradient2 = try JSONDecoder().decode(PAL.Gradient.self, from: g1)

		XCTAssertEqual("first", gradient2.name)
		XCTAssertEqual(3, gradient2.stops.count)
		XCTAssertEqual(0, gradient2.stops[0].position)
		XCTAssertEqual("#ffffffff", gradient2.stops[0].color.hexRGBA)
		XCTAssertEqual(0.5, gradient2.stops[1].position)
		XCTAssertEqual("#444444ff", gradient2.stops[1].color.hexRGBA)
		XCTAssertEqual(1.0, gradient2.stops[2].position)
		XCTAssertEqual("#000000ff", gradient2.stops[2].color.hexRGBA)
	}


	func testBasicWithNoName() throws {
		let gradient = PAL.Gradient(
			colors: [
				try PAL.Color(rgbHexString: "#FFFFFFFF"),
				try PAL.Color(rgbHexString: "#444444FF"),
				try PAL.Color(rgbHexString: "#000000FF")
			]
		)

		XCTAssertEqual(3, gradient.stops.count)
		XCTAssertEqual(0, gradient.stops[0].position)
		XCTAssertEqual("#ffffffff", gradient.stops[0].color.hexRGBA)
		XCTAssertEqual(0.5, gradient.stops[1].position)
		XCTAssertEqual("#444444ff", gradient.stops[1].color.hexRGBA)
		XCTAssertEqual(1.0, gradient.stops[2].position)
		XCTAssertEqual("#000000ff", gradient.stops[2].color.hexRGBA)

		let g1 = try JSONEncoder().encode(gradient)
		let gradient2 = try JSONDecoder().decode(PAL.Gradient.self, from: g1)

		XCTAssertNil(gradient2.name)
		XCTAssertEqual(3, gradient2.stops.count)
		XCTAssertEqual(0, gradient2.stops[0].position)
		XCTAssertEqual("#ffffffff", gradient2.stops[0].color.hexRGBA)
		XCTAssertEqual(0.5, gradient2.stops[1].position)
		XCTAssertEqual("#444444ff", gradient2.stops[1].color.hexRGBA)
		XCTAssertEqual(1.0, gradient2.stops[2].position)
		XCTAssertEqual("#000000ff", gradient2.stops[2].color.hexRGBA)
	}

	func testUnordered() throws {
		let gradient = PAL.Gradient(
			colors: [
				try PAL.Color(rgbHexString: "#FFFFFF"),
				try PAL.Color(rgbHexString: "#444444"),
				try PAL.Color(rgbHexString: "#000000")
			],
			positions: [0.2, 1, 0]
		).sorted

		// Positions should be ordered once the gradient is created

		XCTAssertEqual(3, gradient.stops.count)
		XCTAssertEqual(0, gradient.stops[0].position)
		XCTAssertEqual("#000000", gradient.stops[0].color.hexRGB)
		XCTAssertEqual(0.2, gradient.stops[1].position)
		XCTAssertEqual("#ffffff", gradient.stops[1].color.hexRGB)
		XCTAssertEqual(1.0, gradient.stops[2].position)
		XCTAssertEqual("#444444", gradient.stops[2].color.hexRGB)
	}

	func testUnnormalized() throws {
		let gradient = PAL.Gradient(
			colors: [
				try PAL.Color(rgbHexString: "#FFFFFF"),
				try PAL.Color(rgbHexString: "#121212"),
				try PAL.Color(rgbHexString: "#444444"),
				try PAL.Color(rgbHexString: "#000000")
			],
			positions: [100, 0, 5, 85]
		)

		let normalized = try gradient.normalized()

		// Positions should be ordered once the gradient is created, and the
		// positions should be normalized between 0 -> 1

		XCTAssertEqual(4, normalized.stops.count)

		XCTAssertEqual(0, normalized.stops[0].position)
		XCTAssertEqual("#121212", normalized.stops[0].color.hexRGB)
		XCTAssertEqual(0.05, normalized.stops[1].position)
		XCTAssertEqual("#444444", normalized.stops[1].color.hexRGB)
		XCTAssertEqual(0.85, normalized.stops[2].position)
		XCTAssertEqual("#000000", normalized.stops[2].color.hexRGB)
		XCTAssertEqual(1.0, normalized.stops[3].position)
		XCTAssertEqual("#ffffff", normalized.stops[3].color.hexRGB)
	}

	func testUnnormalizedNonZeroed() throws {
		let gradient = PAL.Gradient(
			colors: [
				try PAL.Color(rgbHexString: "#FFFFFF"),
				try PAL.Color(rgbHexString: "#121212"),
				try PAL.Color(rgbHexString: "#444444")
			],
			positions: [60, 45, 30]
		)

		let normalized = try gradient.normalized()

		// Positions should be ordered once the gradient is created, and the
		// positions should be normalized between 0 -> 1

		XCTAssertNil(gradient.name)

		XCTAssertEqual(3, gradient.stops.count)

		XCTAssertEqual(0, normalized.stops[0].position)
		XCTAssertEqual("#444444", normalized.stops[0].color.hexRGB)
		XCTAssertEqual(0.5, normalized.stops[1].position, accuracy: 4)
		XCTAssertEqual("#121212", normalized.stops[1].color.hexRGB)
		XCTAssertEqual(1.0, normalized.stops[2].position)
		XCTAssertEqual("#ffffff", normalized.stops[2].color.hexRGB)
	}

	func testDumbAssertion() throws {
		let gradient = PAL.Gradient(colorPositions: [
			(20, try PAL.Color(rgbHexString: "#FFFFFF")),
			(20, try PAL.Color(rgbHexString: "#000000")),
		])

		XCTAssertThrowsError(try gradient.normalized())
	}

	func testGradientFromPalette() throws {
		let paletteData = """
			GIMP Palette
			Name: mona
			#Description:
			#Colors: 6
			91	64	78	5b404e
			119	90	95	775a5f
			142	116	112	8e7470
			172	155	144	ac9b90
			210	204	184	d2ccb8
			238	238	225	eeeee1
			"""
		let data = paletteData.data(using: .utf8)!
		let palette = try PAL.Coder.GIMP().decode(from: data)

		let gradient = PAL.Gradient(palette: palette)

		XCTAssertEqual("mona", gradient.name)
		XCTAssertEqual(6, gradient.stops.count)

		XCTAssertEqual("#5b404e", gradient.stops[0].color.hexRGB)
		XCTAssertEqual(0, gradient.stops[0].position, accuracy: 0.01)
		XCTAssertEqual("#775a5f", gradient.stops[1].color.hexRGB)
		XCTAssertEqual(0.2, gradient.stops[1].position, accuracy: 0.01)
		XCTAssertEqual("#8e7470", gradient.stops[2].color.hexRGB)
		XCTAssertEqual(0.4, gradient.stops[2].position, accuracy: 0.01)
		XCTAssertEqual("#ac9b90", gradient.stops[3].color.hexRGB)
		XCTAssertEqual(0.6, gradient.stops[3].position, accuracy: 0.01)
		XCTAssertEqual("#d2ccb8", gradient.stops[4].color.hexRGB)
		XCTAssertEqual(0.8, gradient.stops[4].position, accuracy: 0.01)
		XCTAssertEqual("#eeeee1", gradient.stops[5].color.hexRGB)
		XCTAssertEqual(1, gradient.stops[5].position, accuracy: 0.01)
	}
}