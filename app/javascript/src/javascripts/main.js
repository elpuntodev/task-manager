window.PLATZI = {
  init() {
    console.log("Init PLATZI obj");
    PLATZI.misc.selectizeByScope('body');
  },
  tasks: {
    index: {
      setup() {
        console.log("Setup in the index page");
      }
    } 
  },
  misc: {
    selectizeByScope(selector) {
      $(selector).find('.selectize').each((i, el) => {
        $(el).selectize()
      })
    }
  }
}

$(document).on('turbolinks:load', () => {
  PLATZI.init();
})