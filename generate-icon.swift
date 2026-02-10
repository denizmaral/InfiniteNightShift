#!/usr/bin/env swift
import AppKit

// Renders a moon icon: dark blue circular background with a golden moon.fill SF Symbol

func renderIcon(size: Int) -> NSImage {
    let img = NSImage(size: NSSize(width: size, height: size))
    img.lockFocus()

    let ctx = NSGraphicsContext.current!.cgContext
    let rect = CGRect(x: 0, y: 0, width: size, height: size)

    // Rounded-rect background with gradient
    let cornerRadius = CGFloat(size) * 0.22
    let path = CGPath(roundedRect: rect.insetBy(dx: CGFloat(size) * 0.02, dy: CGFloat(size) * 0.02),
                      cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
    ctx.addPath(path)
    ctx.clip()

    let colors = [
        CGColor(red: 0.08, green: 0.08, blue: 0.28, alpha: 1.0),
        CGColor(red: 0.15, green: 0.10, blue: 0.40, alpha: 1.0)
    ]
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                              colors: colors as CFArray, locations: [0.0, 1.0])!
    ctx.drawLinearGradient(gradient,
                           start: CGPoint(x: 0, y: CGFloat(size)),
                           end: CGPoint(x: CGFloat(size), y: 0),
                           options: [])

    // Moon SF Symbol
    let symbolSize = CGFloat(size) * 0.58
    let config = NSImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular)
    if let moon = NSImage(systemSymbolName: "moon.fill", accessibilityDescription: nil)?
        .withSymbolConfiguration(config) {
        let moonSize = moon.size
        let x = (CGFloat(size) - moonSize.width) / 2
        let y = (CGFloat(size) - moonSize.height) / 2
        let moonRect = NSRect(x: x, y: y, width: moonSize.width, height: moonSize.height)

        // Draw moon in golden/amber color
        let tinted = NSImage(size: moonSize)
        tinted.lockFocus()
        NSColor(red: 1.0, green: 0.82, blue: 0.35, alpha: 1.0).set()
        moon.draw(in: NSRect(origin: .zero, size: moonSize),
                  from: .zero, operation: .sourceOver, fraction: 1.0)
        NSRect(origin: .zero, size: moonSize).fill(using: .sourceIn)
        tinted.unlockFocus()

        tinted.draw(in: moonRect, from: .zero, operation: .sourceOver, fraction: 1.0)
    }

    img.unlockFocus()
    return img
}

func savePNG(_ image: NSImage, size: Int, to url: URL) {
    let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                      pixelsWide: size, pixelsHigh: size,
                                      bitsPerSample: 8, samplesPerPixel: 4,
                                      hasAlpha: true, isPlanar: false,
                                      colorSpaceName: .deviceRGB,
                                      bytesPerRow: 0, bitsPerPixel: 0)!
    bitmapRep.size = image.size
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
    image.draw(in: NSRect(x: 0, y: 0, width: bitmapRep.size.width, height: bitmapRep.size.height),
               from: .zero, operation: .copy, fraction: 1.0)
    NSGraphicsContext.restoreGraphicsState()

    let data = bitmapRep.representation(using: .png, properties: [:])!
    try! data.write(to: url)
}

// Generate .iconset
let iconsetPath = "AppIcon.iconset"
let fm = FileManager.default
try? fm.removeItem(atPath: iconsetPath)
try! fm.createDirectory(atPath: iconsetPath, withIntermediateDirectories: true)

let sizes: [(name: String, pts: Int, pixels: Int)] = [
    ("icon_16x16",      16,   16),
    ("icon_16x16@2x",   16,   32),
    ("icon_32x32",      32,   32),
    ("icon_32x32@2x",   32,   64),
    ("icon_128x128",    128,  128),
    ("icon_128x128@2x", 128,  256),
    ("icon_256x256",    256,  256),
    ("icon_256x256@2x", 256,  512),
    ("icon_512x512",    512,  512),
    ("icon_512x512@2x", 512,  1024),
]

for entry in sizes {
    let image = renderIcon(size: entry.pixels)
    // For @2x variants, the NSImage logical size should be the point size
    let output = NSImage(size: NSSize(width: entry.pts, height: entry.pts))
    output.addRepresentation(image.representations.first!)
    savePNG(image, size: entry.pixels,
            to: URL(fileURLWithPath: "\(iconsetPath)/\(entry.name).png"))
    print("Generated \(entry.name).png (\(entry.pixels)x\(entry.pixels))")
}

print("Converting to .icns...")
let task = Process()
task.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
task.arguments = ["-c", "icns", iconsetPath, "-o", "AppIcon.icns"]
try! task.run()
task.waitUntilExit()

if task.terminationStatus == 0 {
    try? fm.removeItem(atPath: iconsetPath)
    print("Created AppIcon.icns")
} else {
    print("iconutil failed with status \(task.terminationStatus)")
}
