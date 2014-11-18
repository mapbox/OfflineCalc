import UIKit

class ViewController: UIViewController, RMMapViewDelegate {

    var map: RMMapView?
    var centerLabel: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Offline Calc"
        self.navigationController?.toolbarHidden = false

        centerLabel = UIBarButtonItem(title: "x, x, x", style: .Plain, target: nil, action: nil)
        centerLabel?.enabled = false

        if (centerLabel != nil) {
            self.toolbarItems = [ UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
                centerLabel!,
                UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil) ]
        }

        map = RMMapView(frame: view.bounds)

        if (map != nil) {
            map!.delegate = self
            view.addSubview(map!)
            self.mapViewRegionDidChange(map)
        }

    }

    func mapViewRegionDidChange(mapView: RMMapView!) {
        centerLabel!.title = NSString(format: "lat: %.5f, lon: %.5f, z: %.2f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude, mapView.zoom)
    }

}
