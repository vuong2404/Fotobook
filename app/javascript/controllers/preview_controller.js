import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.setupFormValidation()
    this.setupImagePreview()

    this.handleToggleCheckbox('photos_delete')
  }

  setupImagePreview() {
    // Xử lý preview nhiều ảnh 
    this.handlePreviewMultiImage("#imageInput", "#imagePreview")

    // Xử lý preview một ảnh sau khi change
    this.handleChangeImagePreview("#user_avatar", "#avatar-preview")
    this.handleChangeImagePreview("#photoInput", "#photoPreview")
    
  }

  handlePreviewMultiImage(inputSelector, previewSelector) {
    let selectedImages = []
    const imageInput = $(inputSelector)[0]
    imageInput && imageInput.addEventListener('change', (event) => {
      selectedImages = [...selectedImages, ...event.target.files];
      imageInput.files = this.updateFileList([...selectedImages])
      this.showSelectedImages(inputSelector, previewSelector, selectedImages);
    })
  }
  
  handleChangeImagePreview(inputSelector, previewSelector) {
    $(inputSelector)[0] && $(inputSelector)[0].addEventListener('change', function(e) {
      let file = e.target.files[0];
      let reader = new FileReader();

      reader.onload = function(e) {
        $(previewSelector)[0].style.background =`url(${reader.result}) center / cover no-repeat`
        $(previewSelector)[0].innerHTML = `<span class="bg-light text-dark mb-2 bg-opacity-75 shadow px-4 py-1 rounded mt-auto mx-auto">CHANGE</span>`
      };

      reader.readAsDataURL(file);
    });



  }

  updateFileList (files) {
    const b = new ClipboardEvent("").clipboardData || new DataTransfer()
    console.log(files)
    for (const file of files) 
      b.items.add(file)
    
      console.log(b)
    return b.files
  }

  showSelectedImages(inputSelector, previewSelector, selectedImages) {
    const imagePreview = $(previewSelector)[0]
    console.log(imagePreview)
    if (imagePreview) {
      imagePreview.innerHTML = ''
      selectedImages.forEach((file) => this.showFiles(file, inputSelector, previewSelector, selectedImages))
    }
  }

  showFiles(file,inputSelector, previewSelector, selectedImages) {
    const _this = this
    const imageInput = $(inputSelector)[0]
    const imagePreview = $(previewSelector)[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        let imgFrame = `
        <div class="image-preview-frame position-relative">
            <img src=${e.target.result} alt="Image preview" class='img-fluid rounded h-100 w-100' />
            <span class="position-absolute btn btn-outline-danger delete-image-btn">X</span>
        </div>`
        imagePreview.innerHTML += imgFrame
        

        const deleteBtns = $(".delete-image-btn")
        deleteBtns && deleteBtns.each((index, btn) => {
          btn.addEventListener('click', (e) => {
            selectedImages.splice(index, 1)
            imageInput.files = _this.updateFileList(selectedImages)
            _this.showSelectedImages(inputSelector, previewSelector, selectedImages)
          });
        });
      }
      reader.readAsDataURL(file)
    }
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


  handleToggleCheckbox(checkboxID) {
    $(`input[id^=${checkboxID}]`) && $(`input[id^=${checkboxID}]`).each((index, checkbox) => {
      $(checkbox).on('change', (e) => {
        let input = e.target
        let label = input.nextElementSibling
        console.log(input, [label])
        if (input.checked) {
          label.innerHTML = `<i class="fa-solid fa-rotate-right"></i>`
          input.previousElementSibling.style.opacity = 0.3
          label.classList.remove('btn-outline-danger')
          label.classList.add('btn-outline-primary')
        } else {
          label.innerHTML = `<i class="fa-solid fa-xmark"></i>`
          label.classList.remove('btn-outline-primary')
          label.classList.add('btn-outline-danger')
          input.previousElementSibling.style.opacity = 1
        }
      })
    })
  }
}
