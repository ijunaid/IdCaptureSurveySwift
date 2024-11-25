//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import ScanditIdCapture
import ScanditCaptureCore

class ScanningViewController: UIViewController {

    private static let licenseKey = "-- ENTER YOUR SCANDIT LICENSE KEY HERE --"
    
    private var context: DataCaptureContext!
    private var camera: Camera?
    private var idCapture: IdCapture!
    private var captureView: DataCaptureView!
    private var overlay: IdCaptureOverlay!
    
    private enum AlertMessages {
        static let unsupportedDocumentTitle = "Unsupported ID"
        static let unsupportedDocumentMessage = "This ID is not accepted. Please try again with another document."
        static let scanFailedTitle = "Scanning Failed"
        static let scanFailedMessage = "Make sure the document is well-lit and free from glare."
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIdCapture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Switch camera on to start streaming frames
        // Enable IdCapture
        idCapture.isEnabled = true
        camera?.switch(toDesiredState: .on)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Switch camera off to stop streaming frames
        // Disable IdCapture
        // Reset IdCapture to discard front side captures when using Front & Back mode
        idCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
    }

    private func setupIdCapture() {
        // initialize ScanditSDK and IdCapture here
        context = DataCaptureContext(licenseKey: Self.licenseKey)
        camera = Camera.default
        camera?.apply(IdCapture.recommendedCameraSettings)
        context.setFrameSource(camera, completionHandler: nil)
        
        captureView = DataCaptureView(context: context, frame: .zero)
        configureCaptureView()
        
        idCapture = IdCapture(context: context, settings: configureIdCaptureSettings())
        idCapture.addListener(self)
        
        overlay = IdCaptureOverlay(idCapture: idCapture, view: captureView)
        overlay.idLayoutStyle = .rounded
    }
    
    private func configureCaptureView() {
        view.addSubview(captureView)
        captureView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            captureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            captureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            captureView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            captureView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureIdCaptureSettings() -> IdCaptureSettings {
        let settings = IdCaptureSettings()
        settings.acceptedDocuments = [IdCard(region: .euAndSchengen), Passport(region: .any)]
        settings.rejectedDocuments = [Passport(region: .vietnam)]
        settings.scannerType = SingleSideScanner(
            enablingBarcode: false,
            machineReadableZone: true,
            visualInspectionZone: false
        )
        return settings
    }
    
    private func processCapturedDocument(capturedId: CapturedId) {
        guard validateDocument(capturedId) else { return }
        DispatchQueue.main.async {
            let detailVC = ResultViewController(capturedId: capturedId)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    private func validateDocument(_ capturedId: CapturedId) -> Bool {
        guard let documentType = capturedId.document else { return false }
        
        if documentType.isPassport() || documentType.isIdCard() {
            return true
        }
        
        showUnsupportedDocumentMessage()
        return false
    }

    
    private func showUnsupportedDocumentMessage() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: AlertMessages.unsupportedDocumentTitle, message: AlertMessages.unsupportedDocumentMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Scan a valid document", style: .default) { _ in
                self.idCapture.isEnabled = true
            })
            self.present(alert, animated: true)
        }
    }
    
    // This function is called when scanning fails due to timeout, glare, or other reasons
    private func showScanErrorDialog() {
        DispatchQueue.main.async {
            // Create an alert controller
            let alertController = UIAlertController( title: AlertMessages.scanFailedTitle,
                                                     message: AlertMessages.scanFailedMessage,
                                                     preferredStyle: .alert)
            
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { _ in
                self.idCapture.isEnabled = true
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alertController.addAction(tryAgainAction)
            alertController.addAction(cancelAction)
            
            // Present the alert dialog
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ScanningViewController: IdCaptureListener {
    func idCapture(_ idCapture: IdCapture, didCapture capturedId: CapturedId) {
        idCapture.isEnabled = false
        processCapturedDocument(capturedId: capturedId)
    }
    
    func idCapture(_ idCapture: IdCapture, didReject capturedId: CapturedId?, reason rejectionReason: RejectionReason) {
        idCapture.isEnabled = false
        if rejectionReason == .notAcceptedDocumentType {
            showUnsupportedDocumentMessage()
        } else {
            showScanErrorDialog()
        }
    }
}



