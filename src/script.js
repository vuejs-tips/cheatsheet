$ = document.querySelector.bind(document)
$on = document.addEventListener.bind(document)
function ready (fn) {
  document.readyState != 'loading' ? fn() : $on('DOMContentLoaded', fn)
}

function hideModal () {
  $('#modal').classList.add('hidden')
  $('#iframe').src = '' // hide from browser search
}

ready(function () {
  $('#modal button, #modal').addEventListener('click', function () {
    hideModal()
  })

  $on('keydown', function (evt) {
      if (evt.keyCode === 27) {
        hideModal()
      }
  })

  $on('click', function (evt) {
    var href
    if (href = evt.target.getAttribute('href')) {
      evt.preventDefault()
      if (href.charAt(0) === '#') {
        href = 'https://vuejs.org/v2/api/' + href
      }
      $('#iframe').src = href
      $('#modal').classList.remove('hidden')
    }
  })
})
