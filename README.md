# Important Note for MRZ and VZI Implementation

As the documentation mentions, the implementation is designed for **MRZ ID cards**. However, the provided **samples** also include cards without **MRZ**. 

**VZI(Visual Inspection Zone)** has been added to the scanner type to address this.

## Testing Only MRZ

If you only want to test MRZ, follow these steps:

1. Open the `ScanningViewController` file.
2. Locate line **92**.
3. Change the following line:

```swift
visualInspectionZone: true

to

```swift
visualInspectionZone: false
