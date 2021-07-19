// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import { Application, Controller } from 'stimulus';

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("turbolinks:load", function () {
  // $(".search_form select").addClass('form-control');

  (() => {
    const application = Application.start()
    application.register('nested-form', class extends Controller {
      static get targets() {
        return [ "links", "template" ]
      }

      connect() {
        this.wrapperClass = this.data.get("wrapperClass") || "nested-fields"
      }

      add_association(event) {
        event.preventDefault()

        var content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
        this.linksTarget.insertAdjacentHTML('beforebegin', content)
      }

      remove_association(event) {
        event.preventDefault()

        let wrapper = event.target.closest("." + this.wrapperClass)

        // New records are simply removed from the page
        if (wrapper.dataset.newRecord == "true") {
          wrapper.remove()

        // Existing records are hidden and flagged for deletion
        } else {
          wrapper.querySelector("input[name*='_destroy']").value = 1
          wrapper.style.display = 'none'
        }
      }
    })
  })()
  
})

