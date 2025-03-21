+      1: # Coffee Roaster Finder for Garmin Edge 1050
+      2: 
+      3: A Connect IQ application that helps cyclists find high-quality coffee roasters during their rides.
+      4: 
+      5: ![Coffee Roaster Finder App](app_screenshot.png)
+      6: 
+      7: ## Features
+      8: 
+      9: - **Find Quality Coffee Roasters**: Discovers specialty coffee roasters near your current location
+     10: - **Quality Filter**: Only shows highly-rated establishments (4.0+ stars)
+     11: - **Distance-Based Sorting**: Results are sorted by proximity to your current location
+     12: - **Availability Information**: Only displays places that are currently open or opening within 30 minutes
+     13: - **Turn-by-Turn Navigation**: Seamlessly navigate to your chosen coffee destination
+     14: - **Detailed Information Display**:
+     15:   - Name of the coffee roaster
+     16:   - Star rating (out of 5.0)
+     17:   - Distance from current location (in km)
+     18:   - Current status (Open/Opening soon)
+     19: 
+     20: ## Requirements
+     21: 
+     22: - Garmin Edge 1050 device
+     23: - Garmin Connect IQ SDK (version 3.2.0 or higher)
+     24: - Google Places API key
+     25: - Active internet connection on your Edge device
+     26: 
+     27: ## Installation
+     28: 
+     29: ### Development Setup
+     30: 
+     31: 1. Install the [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
+     32: 2. Clone this repository
+     33: 3. Obtain a Google Places API key from the [Google Cloud Console](https://console.cloud.google.com/)
+     34: 4. Replace `YOUR_GOOGLE_API_KEY` in the code with your actual API key
+     35: 5. Build the project using the Connect IQ SDK
+     36: 6. Install on your Edge 1050 device
+     37: 
+     38: ### User Installation
+     39: 
+     40: Once published to the Connect IQ Store:
+     41: 
+     42: 1. Open Garmin Connect on your smartphone
+     43: 2. Navigate to the Connect IQ Store
+     44: 3. Search for "Coffee Roaster Finder"
+     45: 4. Download and install the app to your Edge 1050
+     46: 
+     47: ## Usage
+     48: 
+     49: 1. Start the app from your Edge 1050's app menu
+     50: 2. The app will use your current GPS location to find nearby coffee roasters
+     51: 3. Browse through the list of coffee roasters using the device's navigation buttons
+     52: 4. Select a coffee roaster to view more details
+     53: 5. Choose "Navigate" to get turn-by-turn directions to the selected location
+     54: 
+     55: ## Controls
+     56: 
+     57: - **Up/Down Buttons**: Scroll through the list of coffee roasters
+     58: - **Enter/Select Button**: Select a coffee roaster and view navigation options
+     59: - **Back Button**: Return to the previous screen
+     60: 
+     61: ## Technical Details
+     62: 
+     63: The app uses:
+     64: - Garmin Connect IQ SDK's Monkey C programming language
+     65: - Google Places API for location data
+     66: - Haversine formula for accurate distance calculations
+     67: - Garmin's built-in navigation system
+     68: 
+     69: ## Privacy
+     70: 
+     71: This application:
+     72: - Uses your current location to find nearby coffee roasters
+     73: - Sends location data to Google Places API
+     74: - Does not store or share your location data beyond what's needed for the app's functionality
+     75: 
+     76: ## Troubleshooting
+     77: 
+     78: - **No Results Found**: Ensure you have an active internet connection and are in an area with coffee roasters
+     79: - **Navigation Issues**: Make sure your device has a clear GPS signal
+     80: - **App Crashes**: Update to the latest version of the Connect IQ software on your device
+     81: 
+     82: ## Contributing
+     83: 
+     84: Contributions are welcome! Please feel free to submit a Pull Request.
+     85: 
+     86: 1. Fork the repository
+     87: 2. Create your feature branch (`git checkout -b feature/amazing-feature`)
+     88: 3. Commit your changes (`git commit -m 'Add some amazing feature'`)
+     89: 4. Push to the branch (`git push origin feature/amazing-feature`)
+     90: 5. Open a Pull Request
+     91: 
+     92: ## License
+     93: 
+     94: This project is licensed under the MIT License - see the LICENSE file for details.
+     95: 
+     96: ## Acknowledgments
+     97: 
+     98: - Garmin for the Connect IQ platform
+     99: - Google for the Places API
+    100: - Coffee roasters everywhere for keeping cyclists caffeinated
+    101: 
+    102: ---
+    103: 
+    104: *Note: This app is not affiliated with or endorsed by Garmin Ltd. or Google LLC.*