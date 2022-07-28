$(document).ready(function() {
  window.addEventListener("message", function(event) {
    if (event.data.blind === true) {
      $("#overlay").fadeIn(500);
    } else {
      $("#overlay").fadeOut(500);
    }
  });
});
