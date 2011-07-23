var initialValue = document.getElementById("location").value;

function successHandler(location) {
  // don't mess with it if it's changed
  if (document.getElementById("location").value == initialValue && location.coords.accuracy < 1000) {
    document.getElementById("location").value = location.coords.latitude + "," + location.coords.longitude;
  }
}
function errorHandler(error) {
  // alert("failure");
}

// should really set a cookie to not prompt if they've cancelled
navigator.geolocation.getCurrentPosition(successHandler, errorHandler);