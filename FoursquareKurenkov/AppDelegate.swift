import UIKit

struct FoursquareConfig {
    static let clientId = "SKU0UAT42AE4I3M42KPOQZPLX0S3KKPHH3WVEXZGWL5TZL03"
    static let clientSecret = "KJJXE0ZMYC5O5AD0E3BBMZMBB013WSV4MVT51Z4D3VK51R2K"
    static let callbackURL = "foursquare-kurenkov://foursquare"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var authorizationService: AuthorizationService!
    private var api: FoursquareApi!
    private var locationService: LocationService!
    private var imagesServise: ImagesServise!
    private var launchInteractor: LaunchInteractor!
    private var coreDataStack: CoreDataStack!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createServices()

        let launchRouter = LaunchRouter(rootFactory: rootViewControllerFactory(),
                                        loginFactory: loginViewControllerFactory())
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

    private func createServices() {
        let authStorage: AuthorizationServiceStorage = UIDevice.isSimulator ?
            UserDefaultsAuthorizationStorage() : KeychainAuthorizationStorage()
        authorizationService = AuthorizationService(clientId: FoursquareConfig.clientId,
                                                    clientSecret: FoursquareConfig.clientSecret,
                                                    callbackURL: FoursquareConfig.callbackURL,
                                                    storage: authStorage)

        let authorizationErrorHandler = AuthorizationErrorHandler(authorizationService: authorizationService)
        api = FoursquareApi(authTokenProvider: authorizationService,
                                errorHandlers: [authorizationErrorHandler])

        locationService = LocationService()

        imagesServise = ImagesServise(syncCache: MemoryImagesCache(),
                                      asyncCache: DiskImagesCache(name: "ImagesCache"))

        coreDataStack = CoreDataStack(name: "FoursquareKurenkov")
        coreDataStack.setupCoreDataStack()
    }

    private func loginViewControllerFactory() -> ViewControllerFactory {
        return AuthorizationViewControllerFactory(authorizationService: authorizationService)
    }

    private func rootViewControllerFactory() -> ViewControllerFactory {
        let mapFactory = MapViewControllerFactory(api: api, locationService: locationService)

        let favoritesFactory = FavoritesViewControllerFactory(api: api, coreDataStack: coreDataStack)

        let profileFactory = ProfileViewControllerFactory(authorizationService: authorizationService,
                                                          api: api,
                                                          imagesServise: imagesServise)

        return TabBarViewControllerFactory(mapFactory: mapFactory,
                                           favoritesFactory: favoritesFactory,
                                           profileFactory: profileFactory)
    }
}
