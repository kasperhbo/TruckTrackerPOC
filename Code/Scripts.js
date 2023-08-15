var setUpColumns = false;

function InitializeHtml(){   

    var main = window.parent.document;
    // var head = main.getElementsByClassName("ms-nav-listpartform control-addin-form");

    //Setup the html
    var columnHolder = main.getElementsByClassName('simple-column-layout')[0];5
    columnHolder.setAttribute("style", "display: grid; grid-template-columns: repeat(8, 1fr);");

    console.log('innithtml');

    var map = main.getElementsByClassName('control-addin-container');
    //To make sure you pick the right control adding container, in release you need to find something better then this
    if(map.length>1){
        console.log(map.length);
        map = map[map.length-1];
    }
    // var map = main.getElementById('b17');
    if(map == null){
        map = main.getElementById('b18');
    }
    else{
        map.setAttribute("style", "grid-column: span 6;");
    }

    var list = main.getElementById('bh');
    if(list == null){  
        list = main.getElementById('baa');
    }

    if(list != null){        
        list.setAttribute("style", "grid-column: span 2;");    
        console.log('list is setup');
    }else{
        console.log('list is not setup');
    }
    
    setUpColumns = true;  
    window.htmlInitialized = true;

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('InitializeHtmlCallback');
}

function CodeAddress(_address, invokeEvent) {
    window.geocoder.geocode({ 'address': _address }, function (results, status) {
        if (status == 'OK') {
            var latLng = results[0].geometry.location;
            MoveCenterToLocation(latLng);
        } else {
            alert('Error geocoding address: ' + status);
        }
    });
}

function codeAddressNew(_address, callback) {
    window.geocoder.geocode({ 'address': _address }, function (results, status) {
        if (status == 'OK') {
            window.ctrlGoogleMap.setCenter(results[0].geometry.location);
            callback(null, results[0].geometry.location);
        } else {
            callback(status);
        }
    });
}


function MoveCenterToLocation(lat, lng) {
    var center = new google.maps.LatLng(lat, lng);
    window.ctrlGoogleMap.setCenter(center);
}

function SetRoute(startAddress, endAddress, driver) {
    if(!setUpColumns)
    {   
        console.log('not setup columns');
        return;
    }

    codeAddressNew(startAddress, function (error, startCoord) {
        if (error) {
            console.log("error: " + error);
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('SetRouteErrorCallback', [error]);
            return;
        }
    
        codeAddressNew(endAddress, function (error, endCoord) {
            if (error) {
                console.log("error: " + error);
                alert('Error geocoding end address: ' + error);
                return;
            }
    
            const directionsService = new google.maps.DirectionsService();
            const request = {
                origin: startCoord,
                destination: endCoord,
                travelMode: 'DRIVING'
            };

            console.log("driver: " + driver + startAddress + endAddress + ' set the destination');
    
            directionsService.route(request, function (response, status) {
                if (status == 'OK') {
                   // Create a marker at the destination
                    const marker = new google.maps.Marker({
                        position: endCoord,
                        map: window.ctrlGoogleMap,
                        title: 'Destination',
                        label: driver
                    });

                    // Create an info window with some text
                    const infoWindow = new google.maps.InfoWindow({
                        content: 'Destination for driver: ' + driver
                    });

                    // Attach a click event to the marker to show the info window
                    marker.addListener('click', function() {
                        infoWindow.open(window.ctrlGoogleMap, marker);
                    });
                    animateCar(response, driver);
                }
                else {
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('SetRouteErrorCallback', [status]);
                }
            });
        });
    });
}

var carMarkers = [];

function animateCar(path, driverName) {
    if(driverName == null)
    {
        driverName = 'Driver';
    }
    var truckSVG = {
        path: "M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z",
        fillColor: "#FF0000", // Color of the truck. Here, it's red
        fillOpacity: 1.0,
        strokeWeight: 0,
        rotation: 0,
        scale: 2,
        anchor: new google.maps.Point(0.5, 0.5),
        labelOrigin: new google.maps.Point(10,10)
    };

    let carMarker = new google.maps.Marker({
        position: path.routes[0].overview_path[0],
        icon: truckSVG,
        map: window.ctrlGoogleMap,
        label: {
            text: driverName,
            fontSize: "16px",          // Adjust the font size as required
            fontWeight: "bold",       // Optional: If you want the label to be bold
            color: "#FFFFFF",         // The color of the text
            // Adjust x, y to position the label relative to the top-left corner of the icon
        }
    });
    
    
    //window.carMarkers.push({ marker: carMarker, path: path, currentStep: 0, driver: driverName, carReachedDestination: true});
    var index = window.carMarkers.findIndex(x => x.driver == driverName);
    if(index == -1){
        window.carMarkers.push({ marker: carMarker, path: path, currentStep: 0, driver: driverName, carReachedDestination: true});
    }
    else{
        window.carMarkers[index].marker = carMarker;
        window.carMarkers[index].path = path;
        window.carMarkers[index].currentStep = 0;
        window.carMarkers[index].driver = driverName;
        window.carMarkers[index].carReachedDestination = true;
    }
    
    if(window.carMarkers.length == 3){
        StartUpdateCars();
        // UpdateDriverCallbacks();
    }
}

// function SetRoute(startAddress, endAddress, driver) {
//     
//     if(driver != null){
// }

function StartDriving(driverId){
    var driver = window.carMarkers.find(x => x.driver == driverId);
    console.log(driverId);
    if(driver != null){        
        driver.carReachedDestination = false;
    }
}

function StartUpdateCars(){
    const totalAnimationTime = 90000;  // 10 minutes in milliseconds
    const timePerStep = totalAnimationTime / 30;
    window.directionsDisplay = null;

    window.setInterval(function() {
        for (let i = 0; i < window.carMarkers.length; i++) {
            const car = window.carMarkers[i];
            
            if(!car.carReachedDestination){                
                if (car.currentStep < car.path.routes[0].overview_path.length) {

                    car.marker.setPosition(car.path.routes[0].overview_path[car.currentStep]);
                    var lat = car.marker.position.lat().toString();
                    var lon = car.marker.position.lng().toString();
                    //Focus map to the location if the current tracking driver is set
                    if(car.driver == window.currentTrackingDriverName){
                        MoveCenterToLocation(lat, lon);
                    }
                        car.currentStep++;
                } else {
                    car.carReachedDestination = true;
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('DriverReachedDestinationCallback',  [car.driver]);
                    // window.wait
                    // window.setInterval(function() {
                    //     console.log('startUnloading');
                        
                    //     return;
                    // }, 1000);
                    setTimeout(function(){
                        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('DriverStartsUnloading', [car.driver]);
                        setTimeout(function(){
                            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('DriverFinishedUnloading', [car.driver]);
                        }, 2000);
                    }, 2000);
                }
            }
        }
    }, 100);
}


function GetMarkerByDriverName(driverName){
    for (let i = 0; i < window.carMarkers.length; i++) {
        const car = window.carMarkers[i];
        if(car.driver == driverName){
            var lat = car.marker.position.lat().toString();
            var lon = car.marker.position.lng().toString();
            window.currentTrackingDriverName = driverName;
            
            if(window.directionsDisplay != null)
                window.directionsDisplay.setMap(null);

            window.directionsDisplay = new google.maps.DirectionsRenderer({
                map: window.ctrlGoogleMap,
                directions: car.path,
                suppressMarkers: true,
            });

            return Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('GetMarkerByDriverNameCallback',  [true, lat, lon]);
        }
    }
    return  Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('GetMarkerByDriverNameCallback',  [false, 'Could not find driver', '']);
}

function RemoveDriver(driverId){
    var driver = window.carMarkers.find(x => x.driver == driverId);
    if(driver != null){
        driver.marker.setMap(null);
        window.carMarkers.splice(window.carMarkers.indexOf(driver), 1);
    }else{
        alert('Could not find driver ' + driverId + ' to remove');
    }
}

// //this function runs every 2 seconds
// function UpdateDriverCallbacks()
// {
//     const totalAnimationTime = 12000;
//     window.setInterval(function() {
//         var lat = '';
//         var lon = '';

//         window.setInterval(function() {
//             for (let i = 0; i < window.carMarkers.length; i++) {
//                     const car = window.carMarkers[i];
//                     lat = car.marker.position.lat().toString();
//                     lon = car.marker.position.lng().toString();
//                     driver = car.driver;

//                 }
//         }, totalAnimationTime);
//     }, totalAnimationTime);
// }