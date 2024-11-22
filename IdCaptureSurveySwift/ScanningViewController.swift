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

class ScanningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIdCapture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Switch camera on to start streaming frames
        // Enable IdCapture
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Switch camera off to stop streaming frames
        // Disable IdCapture
        // Reset IdCapture to discard front side captures when using Front & Back mode
    }

    private func setupIdCapture() {
        // initialize ScanditSDK and IdCapture here
    }

    private func openResultViewController() {
        let resultVC = ResultViewController()
        navigationController?.pushViewController(resultVC, animated: true)
    }
}
