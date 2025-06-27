const incr_button = document.getElementById("increment");
const decr_button = document.getElementById("decrement");
const stop_button = document.getElementById("stop");
const convert_button = document.getElementById("convert");

const number_display = document.getElementById("number-display");
const converted_count = document.getElementById("converted-count");
const server_url = "http://localhost:8080";
incr_button.addEventListener("click", async () => {
  try {
    const response = await fetch(server_url + "/data", {
      method: "POST",
      body: JSON.stringify({ increment: true }),
    });
    if (!response.ok) throw new Error("Network response was not ok");
    const data = await response.json();
    number_display.textContent = data.number;
  } catch (error) {
    console.error("Error incrementing number:", error);
  }
});

decr_button.addEventListener("click", async () => {
  try {
    const response = await fetch(server_url + "/data", {
      method: "POST",
      body: JSON.stringify({ decrement: true }),
    });
    if (!response.ok) throw new Error("Network response was not ok");
    const data = await response.json();
    number_display.textContent = data.number;
  } catch (error) {
    console.error("Error decrementing number:", error);
  }
});

stop_button.addEventListener("click", async () => {
  try {
    const response = await fetch(server_url + "/stop_server", {
      method: "POST",
    });
    if (!response.ok) throw new Error("Network response was not ok");
  } catch (error) {
    console.error("Error stopping server:", error);
  }
});

convert_button.addEventListener("click", async () => {
  try {
    const response = await fetch(server_url + "/convert", {
      method: "POST",
    });
    if (!response.ok) throw new Error("Network response was not ok");
    const data = await response.json();
    console.log("Files converted:", data.count);
    converted_count.textContent = data.count;
  } catch (error) {
    console.error("Error converting files:", error);
  }
});
