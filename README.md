# Coffee Roaster Finder for Garmin Edge 1050

A Connect IQ application that helps cyclists find high-quality coffee roasters during their rides.

![Coffee Roaster Finder App](app_screenshot.png)

![Generated Image](https://github.com/user-attachments/assets/6bf3d70e-460b-455b-88f5-70209f6afa6b)


## Features

- **Find Quality Coffee Roasters**: Discovers specialty coffee roasters near your current location
- **Quality Filter**: Only shows highly-rated establishments (4.0+ stars)
- **Distance-Based Sorting**: Results are sorted by proximity to your current location
- **Availability Information**: Only displays places that are currently open or opening within 30 minutes
- **Turn-by-Turn Navigation**: Seamlessly navigate to your chosen coffee destination
- **Detailed Information Display**:
  - Name of the coffee roaster
  - Star rating (out of 5.0)
  - Distance from current location (in km)
  - Current status (Open/Opening soon)

## Requirements

- Garmin Edge 1050 device
- Garmin Connect IQ SDK (version 3.2.0 or higher)
- Google Places API key
- Active internet connection on your Edge device

## Installation

### Development Setup

1. Install the [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
2. Clone this repository
3. Obtain a Google Places API key from the [Google Cloud Console](https://console.cloud.google.com/)
4. Replace `YOUR_GOOGLE_API_KEY` in the code with your actual API key
5. Build the project using the Connect IQ SDK
6. Install on your Edge 1050 device

### User Installation

Once published to the Connect IQ Store:

1. Open Garmin Connect on your smartphone
2. Navigate to the Connect IQ Store
3. Search for "Coffee Roaster Finder"
4. Download and install the app to your Edge 1050

## Usage

1. Start the app from your Edge 1050's app menu
2. The app will use your current GPS location to find nearby coffee roasters
3. Browse through the list of coffee roasters using the device's navigation buttons
4. Select a coffee roaster to view more details
5. Choose "Navigate" to get turn-by-turn directions to the selected location

## Controls

- **Up/Down Buttons**: Scroll through the list of coffee roasters
- **Enter/Select Button**: Select a coffee roaster and view navigation options
- **Back Button**: Return to the previous screen

## Technical Details

The app uses:
- Garmin Connect IQ SDK's Monkey C programming language
- Google Places API for location data
- Haversine formula for accurate distance calculations
- Garmin's built-in navigation system

## Privacy

This application:
- Uses your current location to find nearby coffee roasters
- Sends location data to Google Places API
- Does not store or share your location data beyond what's needed for the app's functionality

## Troubleshooting

- **No Results Found**: Ensure you have an active internet connection and are in an area with coffee roasters
- **Navigation Issues**: Make sure your device has a clear GPS signal
- **App Crashes**: Update to the latest version of the Connect IQ software on your device

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Garmin for the Connect IQ platform
- Google for the Places API
- Coffee roasters everywhere for keeping cyclists caffeinated

---

*Note: This app is not affiliated with or endorsed by Garmin Ltd. or Google LLC.*
