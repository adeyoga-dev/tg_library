import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

  self.window?.makeSecure() // Memanggil fungsi untuk mengamankan tampilan jendela utama

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension UIView {
    func makeSecure() {
        DispatchQueue.main.async {
            let field = UITextField()
            field.isSecureTextEntry = true
            
            // Hack: Masukkan view ini ke dalam layer text field
            self.addSubview(field)
            field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            
            // Pindahkan layer view asli ke dalam layer text field yang secure
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.first?.addSublayer(self.layer)
        }
    }
}
