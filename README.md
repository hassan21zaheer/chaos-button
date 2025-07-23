# Chaos Button
**Chaos Button** is a dynamic Flutter package that provides a customizable button with chaotic random line animations powered by shaders. When tapped, the button displays mesmerizing animated lines that peak and fade, creating a unique visual effect for your Flutter applications.


## Features
- **Chaotic Animations**: Generates random, animated lines using a GLSL shader when the button is tapped.
- **Highly Customizable**: Adjust width, height, border radius, background color, line colors, and animation duration.
- **Interactive**: Supports tap callbacks for integrating with your app’s logic.
- **Shader-Based**: Leverages Flutter’s shader support for smooth, GPU-accelerated animations.
- **Easy Integration**: Simple widget-based API for quick setup in any Flutter project.


## Installation
To use the chaos_button package in your Flutter project, follow these steps:
Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  chaosbutton: ^0.0.1
```

Run flutter pub get to install the package.

💻 Example
Below is a complete example of how to use the ChaosButton in your Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:chaosbutton/chaosbutton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Chaos Button Preview',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: ChaosButton(
            width: 200.0,
            height: 60.0,
            borderRadius: BorderRadius.circular(16.0),
            backgroundColor: Colors.black,
            lineColors: [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
            ],
            animationDuration: const Duration(milliseconds: 500),
            onTap: () {
              print('Button tapped!');
            },
          ),
        ),
      ),
    );
  }
}
```

## Customization Options


- **width**: The width of the button (default: 200.0).

- **height**: The height of the button (default: 60.0).

- **borderRadius**: The border radius of the button (default: 12.0).

- **backgroundColor**: The background color of the button (default: black).

- **lineColors**: A list of up to 4 colors for the animated lines (default: purple, blue, green, orange).

- **animationDuration**: The duration of the tap animation (default: 300ms).

- **onTap**: A callback function triggered on tap.


## Changelog

See the [CHANGELOG.md]() file for updates.

## License

This package is licensed under the MIT License.

## Author

[Hassan Zaheer](https://www.linkedin.com/in/hassanzaheer21/)# chaos-button
