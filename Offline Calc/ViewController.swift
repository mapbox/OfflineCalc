import UIKit

class ViewController: UIViewController, RMMapViewDelegate {

    let tintColor = UIColor(red: 0.120, green: 0.550, blue: 0.670, alpha: 1.000)

    var map: RMMapView?
    var centerLabel: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = tintColor
        view.tintColor = tintColor

        title = "Offline Tile Counts"
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
            map!.autoresizingMask = .FlexibleWidth | .FlexibleHeight
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

        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true

        for zoom in lowZoom...highZoom {
            let zoomCount = map!.tileCache.tileCountForSouthWest(bbox.southWest,
                                                                 northEast: bbox.northEast,
                                                                 minZoom: lowZoom,
                                                                 maxZoom: zoom)
            total += zoomCount

            if let formattedTotal = formatter.stringFromNumber(NSNumber(unsignedLong: zoomCount)) {
                output += "z\(zoom): \(formattedTotal) tiles\n"
            }
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
