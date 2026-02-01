# Minion-Themed Calculator App 🍌

A simple Flutter calculator application with a bright yellow Minion-inspired theme!

## Features ✨

- **Basic Operations**: Addition (+), Subtraction (-), Multiplication (*), and Division (/)
- **Accumulator Display**: Shows the ongoing calculation as you input numbers and operators
- **Order of Operations**: Follows standard algebraic order (PEMDAS/BODMAS)
- **Clear Functionality**: C button to reset the calculator
- **Error Handling**: 
  - Division by zero detection
  - Invalid expression validation
  - Edge case handling
- **User-Friendly UI**: 
  - Bright yellow Minion color scheme
  - Large, easy-to-read display
  - Responsive button layout
  - Visual feedback with colored buttons

## How to Use 🎮

1. **Enter Numbers**: Tap number buttons (0-9) to input digits
2. **Choose Operation**: Select an operator (+, -, *, /)
3. **Continue Calculating**: Keep adding numbers and operators
4. **Get Result**: Press the green = button to calculate
5. **Clear**: Press the orange C button to reset

### Example Calculations

- Simple: `2 + 3 = 5`
- Complex: `2 + 3 * 4 = 14` (follows order of operations)
- Chained: `5 + 3 - 2 * 2 = 4`

## Technical Details 🛠️

- **Framework**: Flutter
- **Expression Evaluator**: `expressions: ^0.2.5` package
- **Language**: Dart
- **UI Theme**: Custom yellow color palette (Minion-inspired)

## Color Scheme 🎨

- Primary Yellow: `#FFD700` (Gold)
- Background: `#F9FBE7` (Light Yellow)
- Display: `#FFF59D` (Light Amber)
- Operator Buttons: `#FFD54F` (Amber)
- Clear Button: `#FF6F00` (Orange)
- Equals Button: `#4CAF50` (Green)

## Running the App 🚀

```bash
# Get dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Run on web
flutter run -d chrome

# Build for production
flutter build apk  # For Android
flutter build ios  # For iOS
flutter build web  # For Web
```

## Testing 🧪

The calculator has been designed to handle:
- ✅ Standard calculations
- ✅ Order of operations
- ✅ Division by zero
- ✅ Long expressions
- ✅ Invalid input sequences
- ✅ Operator replacement (typing a new operator replaces the previous one)

## Author 👨‍💻

**GitHub Copilot**

**Yilmaz Kasapoglu**

---

Made with 💛 and Flutter!
