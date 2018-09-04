// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.10.0/priv/static/phoenix_html.js

var socket = null;
var channel = null;
var brightnessSlider = document.getElementById("brightnessRange");

socket = new Phoenix.Socket("/socket");

socket.connect();

channel = socket.channel("home:lobby")

channel.join()
    .receive("ok", resp =>
      { console.log("Joined successfully", resp) })
    .receive("error", resp =>
      { console.log("Unable to join", resp) })

channel.on("brightness", payload => {
  brightnessSlider.value = payload.value;
});

brightnessSlider.oninput = function() {
  channel.push("brightness", {value: parseInt(this.value)});
  console.log("Brightness:" + this.value);
}
