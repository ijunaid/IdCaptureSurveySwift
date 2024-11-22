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

class ResultViewController: UIViewController {
    private var capturedId: CapturedId
    
    init(capturedId: CapturedId) {
        self.capturedId = capturedId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    private func setupLabels() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Prepare data for labels
        let labelsData: [String] = [
            "Full Name: \(capturedId.fullName)",
            "Date of Birth: \(formatDate(capturedId.dateOfBirth?.utcDate, using: dateFormatter))",
            "Document Number: \(capturedId.documentNumber ?? "N/A")",
            "Expiration Date: \(formatDate(capturedId.dateOfExpiry?.utcDate, using: dateFormatter))"
        ]
        
        // Dynamically create labels
        labelsData.enumerated().forEach { index, text in
            let label = UILabel()
            label.text = text
            label.frame = CGRect(x: 20, y: 100 + index * 40, width: Int(view.frame.width) - 40, height: 30)
            label.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
            label.font = UIFont.systemFont(ofSize: 16)
            view.addSubview(label)
        }
    }
    
    private func formatDate(_ date: Date?, using formatter: DateFormatter) -> String {
        guard let date = date else { return "N/A" }
        return formatter.string(from: date)
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}


