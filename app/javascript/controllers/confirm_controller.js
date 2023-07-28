// import { Controller } from "@hotwired/stimulus";
// import { Modal } from "bootstrap";
// import Rails from '@rails/ujs'


// export default class extends Controller {
//   static values = {
//     title: String,
//     message: String,
//     okButton: String,
//     cancelButton: String,
//     url: String,
//     frame: String,
//     target: String,
//   };

//   connect() {
//     console.log("Confirm controller connect");
//   }

//   click(event) {
//     event.preventDefault();

//     let title = this.titleValue;
//     let msg = this.messageValue;
//     let ok = this.okButtonValue;
//     if (!ok) {
//       ok = "OK";
//     }
//     let cancel = this.cancelButtonValue;
//     if (!cancel) {
//       cancel = "Cancel";
//     }
//     let url = this.urlValue;
//     let frame = this.frameValue;
//     if (frame) {
//       frame = `data-turbo-frame="${frame}"`;
//     }

//     let html = `
//       <div class="modal fade" id="confirmDialog" tabindex="-1" role="dialog" aria-labelledby="ariaConfirmModal" aria-hidden="true">
//         <div class="modal-dialog">
//           <div class="modal-content">
//             <div class="modal-header">
//               <h5 class="modal-title" id="confirmModalTitle">${title}</h5>
//               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
//             </div>
//             <div class="modal-body">
//               ${msg}
//             </div>
//             <div class="modal-footer">
//               <button type="button" class="btn btn-link" id="confirmModalCancelButton" data-bs-dismiss="modal">${cancel}</button>
//               <button type="button" class="btn btn-primary"
//                 ${frame} data-bs-dismiss="modal"
//                 id="confirmModalConfirmButton">${ok}</button>
//             </div>
//           </div>
//         </div>
//       </div>
//       `;

//     var tempDiv = document.createElement("div");
//     tempDiv.id = "temp-html";
//     tempDiv.innerHTML = html;
//     document.body.append(tempDiv);

//     let m = document.querySelector("#confirmDialog");
//     var confirmModal = new Modal(m);
//     confirmModal.show();

//     let confirmButton = m.querySelector("#confirmModalConfirmButton");
//     confirmButton.addEventListener("click", function () {
//       confirmButton.classList.add('disabled')
//       fetch(url, {
//         method: "DELETE",
//         headers: {
//           "X-CSRF-Token": Rails.csrfToken(),
//           "Accept": "text/vnd.turbo-stream.html",
//           "Content-Type": "application/json",
//         },
//         body: JSON.stringify({}),
//       })
//         .then((response) => response.json())
//         .then((data) => {
//           if (data.result == true) {
//             const userRow = document.querySelector(`tr[data-user-id="${data.user_id}"]`);
//             if (userRow) {
//               userRow.remove();
//             }
//           }
//         })
//         .catch((error) => {
//           console.error(error);
//         })
//         .finally(() => {
//           confirmButton.classList.remove('disabled')
//           confirmModal.hide();
//           tempDiv.remove();
//         });
//     });

//     m.addEventListener("hidden.bs.modal", function (event) {
//       // confirmButton.removeEventListener("click");
//       tempDiv.remove();
//     });
//   }
// }
import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap";

export default class extends Controller {
  static values = {
    title: String,
    message: String,
    okButton: String,
    cancelButton: String,
    url: String,
    method: String,
    frame: String
  }

  connect() {
    console.log('Confirm controller connect');
  }

  click(event) {  
    event.preventDefault();

    let title = this.titleValue;
    let msg = this.messageValue;
    let ok = this.okButtonValue;
    if (!ok) { ok = 'OK'; }
    let cancel = this.cancelButtonValue;
    if (!cancel) { cancel = 'Cancel'; }
    let url = this.urlValue;
    let method = this.methodValue;
    if (!method) { method = 'get'; }
    let frame = this.frameValue
    if (frame) {
      frame = `data-turbo-frame="${frame}"`;
    }

    let dMethod = method === 'get' ? '' : " data-method=\"" + method + "\"";

    let html = `
      <div class="modal fade" id="confirmDialog" tabindex="-1" role="dialog" aria-labelledby="ariaConfirmModal" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="confirmModalTitle">${title}</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              ${msg}
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-link" id="confirmModalCancelButton" data-bs-dismiss="modal">${cancel}</button>
              <a href="${url}" ${dMethod} class="btn btn-primary"
                ${frame} data-bs-dismiss="modal"
                id="confirmModalConfirmButton">${ok}</a>
            </div>
          </div>
        </div>
      </div >
      `;

    var tempDiv = document.createElement('div');
    tempDiv.id = 'temp-html';
    tempDiv.innerHTML = html;
    document.body.append(tempDiv);

    let m = document.querySelector('#confirmDialog');
    var confirmModal = new Modal(m);
    confirmModal.show();

    m.addEventListener('hidden.bs.modal', function (event) {
      tempDiv.remove();
    })

  }
}



