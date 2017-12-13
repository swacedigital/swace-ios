import UIKit
import XCTest
import Swace

class RoutingTests: XCTestCase {

    let firstModule = RoutableModule(path: "profile")
    let secondModule = RoutableModule(path: "external")

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        Router.shared.set(routes:
            [Route.init(module: firstModule, wireframe: BaseWireframe())
        ], for: Scheme(name: "app://"))

        Router.shared.set(routes:
            [Route.init(module: secondModule, wireframe: BaseWireframe())
            ], for: Scheme(name: "facebook://"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRoutingToModuleOneWithoutOptions() {
        XCTAssertNoThrow(try Router.navigate(to: firstModule))
    }

    func testRoutingToModuleTwoWithOptions() {
        XCTAssertNoThrow(try Router.navigate(to: secondModule))
    }

}
