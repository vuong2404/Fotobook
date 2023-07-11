// app/javascript/controllers/custom_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.setupFormValidation()
    this.setupImagePreview()
  }

  setupFormValidation() {
    const forms = document.querySelectorAll('.needs-validation')
    Array.from(forms).forEach(form => {
      form.addEventListener('submit', event => {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }
        form.classList.add('was-validated')
      }, false)
    })
  }

  setupImagePreview() {
    const imageInput = document.getElementById('imageInput')
    const imagePreview = document.getElementById('imagePreview')

    imageInput.addEventListener('change', (event) => {
      const file = event.target.files[0]

      if (file) {
        const reader = new FileReader()
        reader.onload = (e) => {
          const img = document.createElement('img')
          img.src = e.target.result
          img.classList.add('image-preview-frame')
          img.alt = 'Image Preview'
          imagePreview.appendChild(img)
        }
        reader.readAsDataURL(file)
      } else {
        imagePreview.innerHTML = ''
      }
    })
  }
}
