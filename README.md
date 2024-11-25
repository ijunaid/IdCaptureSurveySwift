# Important Note for MRZ and VIZ Implementation

The implementation is primarily designed for **MRZ ID cards**, as mentioned in the task instructions document. However, the provided **samples** also include cards without **MRZ**, which require the **VIZ** (Visual Inspection Zone) scanner type.

## Testing Both MRZ and VIZ

To test both MRZ and VIZ functionality, follow these steps:

1. Open the `ScanningViewController` file.
2. Locate line **92**.
3. Modify the following line:

```swift
visualInspectionZone: false

to

visualInspectionZone: true
