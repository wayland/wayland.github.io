var LAYOUT_WIDTH_KEY = 'layoutWidth';

function syncLayoutWidthMenuDefault() {
  var menu = document.querySelector('.layout-width-menu');
  if (!menu) return;
  var pref = localStorage.getItem(LAYOUT_WIDTH_KEY);
  menu.setAttribute('data-default', pref ? pref : 'auto');
}

function setLayoutWidth(mode, persist) {
  var box = document.querySelector('.wide-box');
  if (!box) return;
  if (persist === undefined) persist = true;
  if (mode === 'auto') mode = '';

  box.classList.remove('narrow', 'wide', 'huge');
  if (mode) {
    box.classList.add(mode);
  } else {
    var author = box.getAttribute('data-page-width');
    if (author && author !== 'landing') box.classList.add(author);
  }

  if (persist) {
    if (mode) localStorage.setItem(LAYOUT_WIDTH_KEY, mode);
    else localStorage.removeItem(LAYOUT_WIDTH_KEY);
    syncLayoutWidthMenuDefault();
  }
}

function applyStoredLayoutWidth() {
  syncLayoutWidthMenuDefault();
  var box = document.querySelector('.wide-box');
  if (!box) return;
  if (box.getAttribute('data-page-width')) return;
  var pref = localStorage.getItem(LAYOUT_WIDTH_KEY);
  if (pref) setLayoutWidth(pref, false);
}

applyStoredLayoutWidth();
