@testable import ASEPalette
import XCTest

let aco_resources = [
	"davis-colors-concrete-pigments",
	"Material Palette",
	"454306_iColorpalette"
]

final class ACOSwatchesTests: XCTestCase {
	func testWriteReadRoundTripSampleACOFiles() throws {
		Swift.print("Round-tripping ACO files...'")
		// Loop through all the resource files
		for name in aco_resources {
			let controlACO = try XCTUnwrap(Bundle.module.url(forResource: name, withExtension: "aco"))
			let origData = try Data(contentsOf: controlACO)

			Swift.print("Validating '\(name)...'")

			// Attempt to load the ase file
			let swatches = try ASE.ACOColorSwatch(fileURL: controlACO)

			// Write to a data stream
			let data = try swatches.data()

			// Check that the generated data matches the original data exactly
			XCTAssertEqual(origData, data)

			// Re-create the ase structure from the written data ...
			let reconstitutedSwatches = try ASE.ACOColorSwatch(data: data)

			// ... and check equality between the original file and our reconstituted one.
			XCTAssertEqual(swatches, reconstitutedSwatches)
		}
	}

	func testACOBasic() throws {
		let acoURL = try XCTUnwrap(Bundle.module.url(forResource: "davis-colors-concrete-pigments", withExtension: "aco"))

		let aco = try ASE.ACOColorSwatch(fileURL: acoURL)
		XCTAssertEqual(59, aco.colors.count)
	}

	func testACOGoogleMaterial() throws {
		let acoURL = try XCTUnwrap(Bundle.module.url(forResource: "Material Palette", withExtension: "aco"))

		let aco = try ASE.ACOColorSwatch(fileURL: acoURL)
		XCTAssertEqual(256, aco.colors.count)

		XCTAssertEqual("Red 500 - Primary", aco.colors[0].name)
		XCTAssertEqual("ffffff", aco.colors[255].name)
	}
}