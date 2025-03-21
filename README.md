# garmin-roaster
Small application created using amazon q developer to locate top coffee roasters in the vicinity using a Garmin Edge cycling computer


Key improvements in this version:

1. Rating Filter: Only shows coffee roasters with ratings of 4.0 or higher
2. Distance Calculation: Calculates and displays the distance from your current location
3. Sorting: Sorts results by distance (closest first)
4. Opening Hours: Shows only places that are currently open or opening within the next 30 minutes
5. Status Display: Shows "Open" or "Opening soon" status for each location
6. Enhanced UI:
   • Displays both distance and rating for each roaster
   • Color-coded status indicators (green for open, orange for opening soon)
   • Pagination for scrolling through results
   • Scroll indicators when more results are available
   • Count of total results found

7. Google Places API: Uses Google's API for more reliable data on ratings, opening hours, and business details

To use this app:
1. You'll need to obtain a Google Places API key and replace YOUR_GOOGLE_API_KEY with your actual key
2. The app handles pagination for viewing multiple results
3. Navigation works the same as before, using Garmin's built-in navigation system

This enhanced version provides a much more useful experience for cyclists looking for quality coffee roasters during their ride, with clear information about distance, ratings, and 
availability.
