import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleBtn = $(".sidebar-toggle-btn")[0]
  sidebar =  $(".admin-sidebar-container")[0]
  content = $(".admin-main-content")[0]
  connect() {
    console.log(this.toggleBtn, this.sidebar, this.content)
    const _this = this ;
    if (this.toggleBtn && this.sidebar && this.content) {
      // make a default sidebar position
      window.onresize = function() {
        // hidden sidebar if sceeen width < 992px
        // show sidebar in large screen
        if (window.innerWidth <= 992) {
          _this.sidebar.style.left === '0px' && this.close()
        } else {
          _this.sidebar.style.left !== '0px' && this.show()
        }
      };

      // Handle open/close sidebar
      $(this.toggleBtn).on("click", () => {
        console.log("click", _this.sidebar.style.left)
        _this.sidebar.style.left === '0px' ? _this.close() : _this.show() 
      })  
    } else {
      console.log("Dom not found!")
    }
  }

  close() {
    console.log("close")
    this.sidebar.style.left = "calc(0px - var(--admin-sidebar-width))"
    this.content.style.marginLeft = 0;
  }

  show() {
    console.log("show")
    this.sidebar.style.left = 0 ;
    this.content.style.marginLeft = window.innerWidth <= 992 ? 0 : "var(--admin-sidebar-width)" 
  }
}
