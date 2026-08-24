import Foundation

@main
enum BroadExtensionsContractProbe {
    static func main() {
        expect("FFF", equals: (1, 1, 1, 1))
        expect("#0F08", equals: (0, 1, 0, 136.0 / 255.0))
        expect("336699", equals: (51.0 / 255.0, 102.0 / 255.0, 153.0 / 255.0, 1))
        expect("33669980", equals: (51.0 / 255.0, 102.0 / 255.0, 153.0 / 255.0, 128.0 / 255.0))

        for invalid in ["", "12", "12345", "GGGGGG", "#123456789"] {
            guard BroadRGBAColor(hex: invalid) == nil else {
                fail("invalid value was accepted: \(invalid)")
            }
        }
    }

    private static func expect(
        _ hex: String,
        equals expected: (Double, Double, Double, Double)
    ) {
        guard let actual = BroadRGBAColor(hex: hex),
              approximatelyEqual(actual.red, expected.0),
              approximatelyEqual(actual.green, expected.1),
              approximatelyEqual(actual.blue, expected.2),
              approximatelyEqual(actual.alpha, expected.3)
        else {
            fail("unexpected RGBA for \(hex)")
        }
    }

    private static func approximatelyEqual(_ lhs: Double, _ rhs: Double) -> Bool {
        abs(lhs - rhs) < 0.000_001
    }

    private static func fail(_ message: String) -> Never {
        FileHandle.standardError.write(Data("Contract violation: \(message)\n".utf8))
        Foundation.exit(1)
    }
}
