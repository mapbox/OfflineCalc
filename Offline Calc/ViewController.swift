import UIKit

class ViewController: UIViewController, RMMapViewDelegate {

    var map: RMMapView?
    var centerLabel: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Offline Calc"
        navigationController?.toolbarHidden = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize,
                                                            target: self,
                                                            action: "calculateOffline")

        centerLabel = UIBarButtonItem(title: "x, x, x", style: .Plain, target: nil, action: nil)
        centerLabel?.enabled = false

        if (centerLabel != nil) {
            toolbarItems = [ UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                             target: nil,
                                             action: nil),
                             centerLabel!,
                             UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                             target: nil,
                                             action: nil) ]
        }

        map = RMMapView(frame: view.bounds)

        if (map != nil) {
            map!.delegate = self
            view.addSubview(map!)
            mapViewRegionDidChange(map)
        }

    }

    func calculateOffline() {
        let bbox = map!.latitudeLongitudeBoundingBox()

        var output = "\n"

        let lowZoom = UInt(floor(map!.zoom))
        let highZoom:UInt = 20

        var total: UInt = 0

        for zoom in lowZoom...highZoom {
            let zoomCount = map!.tileCache.tileCountForSouthWest(bbox.southWest,
                                                                 northEast: bbox.northEast,
                                                                 minZoom: lowZoom,
                                                                 maxZoom: zoom)
            total += zoomCount
            output += "z\(zoom): \(zoomCount) tiles\n"
        }

        let alert = UIAlertController(title: "Tile Counts",
                                      message: output,
                                      preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .Default,
                                      handler: { [unowned self] (action) in
                                          self.dismissViewControllerAnimated(true, completion: nil)
                                      }))

        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }

    func mapViewRegionDidChange(mapView: RMMapView!) {
        centerLabel!.title = NSString(format: "lat: %.5f, lon: %.5f, z: %.2f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude, mapView.zoom)
    }

}
