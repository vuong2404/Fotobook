// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "@popperjs/core"
import "bootstrap"

Turbo.setConfirmMethod((message, element) => {
  console.log(message, element)
  let dialog = document.getElementById("turbo-confirm")
  dialog.querySelector(".message").textContent = message
  dialog.showModal()

  return new Promise((resolve, reject) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue == "confirm")
    }, { once: true })
  })
})

