// var coordinates = { lat: 52.3443982, lng: 6.0491498};
var coords;

function initMap()
{
  window.geocoder = new google.maps.Geocoder();

  window.ctrlGoogleMap = new google.maps.Map(document.getElementById('controlAddIn'), {
    zoom: 14,
    center: { lat: 52.3443982, lng: 6.0491498 },
    scrollwheel: true,
    mapTypeId: google.maps.MapTypeId.HYBRID
  });
}

initMap();

Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlReady', []);

