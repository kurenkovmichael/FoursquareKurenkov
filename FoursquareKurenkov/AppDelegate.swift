import UIKit

struct FoursquareConfig {
    static let clientId = "SKU0UAT42AE4I3M42KPOQZPLX0S3KKPHH3WVEXZGWL5TZL03"
    static let clientSecret = "KJJXE0ZMYC5O5AD0E3BBMZMBB013WSV4MVT51Z4D3VK51R2K"
    static let callbackURL = "foursquare-kurenkov://foursquare"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var authorizationService: AuthorizationService!
    private var launchInteractor: LaunchInteractor!
    private var api: FoursquareApi!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        authorizationService = AuthorizationService(clientId: FoursquareConfig.clientId,
                                                    clientSecret: FoursquareConfig.clientSecret,
                                                    callbackURL: FoursquareConfig.callbackURL,
                                                    storage: UserDefaultsAuthorizationStorage())

        let authorizationErrorHandler = AuthorizationErrorHandler(authorizationService: authorizationService)
        api = FoursquareApi(authTokenProvider: authorizationService,
                            errorHandlers: [authorizationErrorHandler])

        let imagesServise = ImagesServise(syncCache: MemoryImagesCache(),
                                          asyncCache: DiskImagesCache(name: "ImagesCache"))

        let launchViewControllersFactory
            = LaunchViewControllersFactory(authorizationService: authorizationService,
                                           api: api,
                                           imagesServise: imagesServise)
        let launchRouter = LaunchRouter(viewControllersFactory: launchViewControllersFactory)
        launchInteractor = LaunchInteractor(launchRouter: launchRouter,
                                            authorizationService: authorizationService)

        launchInteractor.launchApplication()
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        authorizationService.handleURL(url: url)
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        var didHandle = false
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            authorizationService.handleURL(url: userActivity.webpageURL!)
            didHandle = true
        }
        return didHandle
    }

}
