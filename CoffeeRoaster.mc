using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Position;
using Toybox.Communications;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

// Replace with your actual Google API key
const GOOGLE_API_KEY = "YOUR_GOOGLE_API_KEY";

class CoffeeRoasterApp extends Application.AppBase {
    private var view;
    private var roasterList;
    private var currentLat;
    private var currentLon;

    function initialize() {
        AppBase.initialize();
        roasterList = [];
    }

    function onStart(state) {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    function onStop(state) {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function onPosition(info) {
        if (info.position != null) {
            currentLat = info.position.toDegrees()[0];
            currentLon = info.position.toDegrees()[1];
            fetchNearbyRoasters(currentLat, currentLon);
        }
    }

    private function fetchNearbyRoasters(lat, lon) {
        // Use Google Places API to find coffee roasters
        var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
        var params = {
            "location" => lat.toString() + "," + lon.toString(),
            "radius" => "5000",  // 5km radius
            "keyword" => "coffee roaster",
            "type" => "establishment",
            "opennow" => "true",  // Only places that are open now
            "fields" => "name,rating,vicinity,opening_hours,geometry",
            "key" => GOOGLE_API_KEY
        };

        Communications.makeWebRequest(url, params, 
            {
                :method => Communications.HTTP_REQUEST_METHOD_GET,
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            }, 
            method(:onReceiveRoasters)
        );
    }

    function onReceiveRoasters(responseCode, data) {
        if (responseCode == 200 && data != null && data.hasKey("results")) {
            var results = data["results"];
            roasterList = [];
            
            for (var i = 0; i < results.size(); i++) {
                var place = results[i];
                
                // Calculate distance from current location
                var roasterLat = place["geometry"]["location"]["lat"].toFloat();
                var roasterLon = place["geometry"]["location"]["lng"].toFloat();
                var distance = calculateDistance(currentLat, currentLon, roasterLat, roasterLon);
                
                // Only include places with rating >= 4.0
                if (place.hasKey("rating") && place["rating"] >= 4.0) {
                    var openingHoursStatus = "";
                    if (place.hasKey("opening_hours")) {
                        if (place["opening_hours"]["open_now"]) {
                            openingHoursStatus = "Open";
                        }
                    }
                    
                    // Get detailed place info including opening hours
                    if (place.hasKey("place_id")) {
                        getPlaceDetails(place["place_id"], distance, place);
                    } else {
                        roasterList.add({
                            "name" => place["name"],
                            "rating" => place.hasKey("rating") ? place["rating"].toFloat() : 0.0,
                            "distance" => distance,
                            "lat" => roasterLat,
                            "lon" => roasterLon,
                            "status" => openingHoursStatus
                        });
                    }
                }
            }
            
            // Sort by distance
            sortRoastersByDistance();
            WatchUi.requestUpdate();
        }
    }
    
    function getPlaceDetails(placeId, distance, basicInfo) {
        var url = "https://maps.googleapis.com/maps/api/place/details/json";
        var params = {
            "place_id" => placeId,
            "fields" => "name,rating,opening_hours,geometry",
            "key" => GOOGLE_API_KEY
        };
        
        Communications.makeWebRequest(url, params, 
            {
                :method => Communications.HTTP_REQUEST_METHOD_GET,
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            }, 
            method(:onReceivePlaceDetails).bind(distance, basicInfo)
        );
    }
    
    function onReceivePlaceDetails(distance, basicInfo, responseCode, data) {
        if (responseCode == 200 && data != null && data.hasKey("result")) {
            var result = data["result"];
            var status = "Closed";
            var openingSoon = false;
            
            if (result.hasKey("opening_hours")) {
                if (result["opening_hours"]["open_now"]) {
                    status = "Open";
                } else if (result["opening_hours"].hasKey("periods")) {
                    // Check if opening within 30 minutes
                    var now = Time.now();
                    var currentTime = Gregorian.info(now, Time.FORMAT_SHORT);
                    var currentMinutes = currentTime.hour * 60 + currentTime.min;
                    
                    var periods = result["opening_hours"]["periods"];
                    for (var i = 0; i < periods.size(); i++) {
                        if (periods[i].hasKey("open")) {
                            var openHour = periods[i]["open"]["hour"].toNumber();
                            var openMinute = periods[i]["open"]["minute"].toNumber();
                            var openingTime = openHour * 60 + openMinute;
                            
                            if (openingTime > currentMinutes && openingTime <= (currentMinutes + 30)) {
                                status = "Opening soon";
                                openingSoon = true;
                                break;
                            }
                        }
                    }
                }
            }
            
            // Only add if open or opening soon
            if (status == "Open" || openingSoon) {
                roasterList.add({
                    "name" => basicInfo["name"],
                    "rating" => basicInfo.hasKey("rating") ? basicInfo["rating"].toFloat() : 0.0,
                    "distance" => distance,
                    "lat" => basicInfo["geometry"]["location"]["lat"].toFloat(),
                    "lon" => basicInfo["geometry"]["location"]["lng"].toFloat(),
                    "status" => status
                });
                
                // Re-sort and update UI
                sortRoastersByDistance();
                WatchUi.requestUpdate();
            }
        }
    }
    
    function calculateDistance(lat1, lon1, lat2, lon2) {
        var R = 6371; // Earth radius in km
        var dLat = (lat2 - lat1) * Math.PI / 180;
        var dLon = (lon2 - lon1) * Math.PI / 180;
        var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
                Math.sin(dLon/2) * Math.sin(dLon/2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        var d = R * c;
        return d;
    }
    
    function sortRoastersByDistance() {
        // Simple bubble sort by distance
        for (var i = 0; i < roasterList.size(); i++) {
            for (var j = i + 1; j < roasterList.size(); j++) {
                if (roasterList[i]["distance"] > roasterList[j]["distance"]) {
                    var temp = roasterList[i];
                    roasterList[i] = roasterList[j];
                    roasterList[j] = temp;
                }
            }
        }
    }

    function getInitialView() {
        view = new CoffeeRoasterView(roasterList);
        return [view];
    }
}

class CoffeeRoasterView extends WatchUi.View {
    private var roasters;
    private var selectedIndex;
    private var scrollPosition;
    private var maxVisibleItems;

    function initialize(roasterList) {
        View.initialize();
        roasters = roasterList;
        selectedIndex = 0;
        scrollPosition = 0;
        maxVisibleItems = 4; // Number of items visible on screen at once
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        if (roasters.size() == 0) {
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 30, 
                       Graphics.FONT_MEDIUM, "Searching for coffee roasters...",
                       Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 10, 
                       Graphics.FONT_SMALL, "Looking for highly rated places",
                       Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 40, 
                       Graphics.FONT_SMALL, "that are open or opening soon",
                       Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }

        // Display header
        dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, 5, Graphics.FONT_MEDIUM, 
                   "Coffee Roasters (" + roasters.size() + ")",
                   Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw separator line
        dc.drawLine(10, 30, dc.getWidth() - 10, 30);

        // Display roaster list with pagination
        var yPos = 40;
        var endIdx = Math.min(scrollPosition + maxVisibleItems, roasters.size());
        
        for (var i = scrollPosition; i < endIdx; i++) {
            var roaster = roasters[i];
            
            // Highlight selected item
            if (i == selectedIndex) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            }
            
            // Format distance to 1 decimal place
            var distStr = roaster["distance"].format("%.1f") + "km";
            
            // Draw name
            dc.drawText(10, yPos, Graphics.FONT_MEDIUM, roaster["name"], Graphics.TEXT_JUSTIFY_LEFT);
            
            // Draw rating and distance on next line
            var ratingText = "★ " + roaster["rating"].format("%.1f");
            dc.drawText(10, yPos + 25, Graphics.FONT_SMALL, ratingText, Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(dc.getWidth() - 10, yPos + 25, Graphics.FONT_SMALL, distStr, Graphics.TEXT_JUSTIFY_RIGHT);
            
            // Draw status (Open/Opening soon)
            var statusColor = (roaster["status"] == "Open") ? Graphics.COLOR_DK_GREEN : Graphics.COLOR_ORANGE;
            dc.setColor(statusColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() - 10, yPos, Graphics.FONT_SMALL, roaster["status"], Graphics.TEXT_JUSTIFY_RIGHT);
            
            // Reset color and draw separator
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(10, yPos + 50, dc.getWidth() - 10, yPos + 50);
            
            yPos += 55;
        }
        
        // Draw scroll indicators if needed
        if (scrollPosition > 0) {
            dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()/2, 30, Graphics.FONT_SMALL, "▲", Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        if (endIdx < roasters.size()) {
            dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()/2, dc.getHeight() - 20, Graphics.FONT_SMALL, "▼", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    function onSelect() {
        if (roasters.size() > 0 && selectedIndex < roasters.size()) {
            var selected = roasters[selectedIndex];
            startNavigation(selected["lat"], selected["lon"]);
        }
    }
    
    function onNextPage() {
        if (selectedIndex < roasters.size() - 1) {
            selectedIndex++;
            
            // Adjust scroll position if needed
            if (selectedIndex >= scrollPosition + maxVisibleItems) {
                scrollPosition = selectedIndex - maxVisibleItems + 1;
            }
            
            WatchUi.requestUpdate();
        }
        return true;
    }
    
    function onPreviousPage() {
        if (selectedIndex > 0) {
            selectedIndex--;
            
            // Adjust scroll position if needed
            if (selectedIndex < scrollPosition) {
                scrollPosition = selectedIndex;
            }
            
            WatchUi.requestUpdate();
        }
        return true;
    }

    function startNavigation(lat, lon) {
        var navParams = {
            :startPoint => Activity.getActivityInfo().currentLocation,
            :endPoint => new Position.Location({
                :latitude => lat,
                :longitude => lon,
                :format => :degrees
            })
        };
        Activity.startNavigation(navParams);
    }
}

// Input handler for button presses
class CoffeeRoasterInputDelegate extends WatchUi.InputDelegate {
    private var view;
    
    function initialize(coffeeView) {
        InputDelegate.initialize();
        view = coffeeView;
    }
    
    function onKey(keyEvent) {
        if (keyEvent.getKey() == WatchUi.KEY_DOWN) {
            return view.onNextPage();
        } else if (keyEvent.getKey() == WatchUi.KEY_UP) {
            return view.onPreviousPage();
        } else if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            view.onSelect();
            return true;
        }
        return false;
    }
}

function getApp() as CoffeeRoasterApp {
    return Application.getApp() as CoffeeRoasterApp;
}