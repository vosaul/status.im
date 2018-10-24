// let ScrollOver = require("./lib/ScrollOver.js")
// let animateScroll = require("./lib/animatescroll.js")
// let d3 = require("d3")

$(document).ready(function () {
  let url = 'https://our.status.im/ghost/api/v0.1/posts/?order=published_at%20desc&limit=3&formats=plaintext&client_id=ghost-frontend&client_secret=2b055fcd57ba';
  var urlBase = [location.protocol, '//', location.host, location.pathname].join('');

  $.ajax({
    type: "get",
    url: url,
    success: function (response) {
      response.posts = response.posts.reverse();
      $.each(response.posts, function (index, val) { 
        var excerpt = '';
        if(val.custom_excerpt != null) {
          excerpt = val.custom_excerpt;
        }else{
          excerpt = getWords(val.plaintext);
        }
        $('.latest-posts').prepend(' \
        <div class="info-item"> \
            <div class="info-item-content"> \
                <h4><a href="https://our.status.im/'+ val.slug +'">'+ val.title +'</a></h3> \
                <p class="secondary-text">'+ excerpt +'</p> \
            </div> \
            <div class="info-item-link"> \
                <a href="https://our.status.im/'+ val.slug +'" class="link-arrow">Read more </a>  \
            </div> \
        </div> \
        ');
      });
    }
  });

  function getWords(str) {
    return str.split(/\s+/).slice(0,25).join(" ");
  }

});

let heroImage = document.querySelectorAll(".hero-image")[0]

if(heroImage) {
  setTimeout(function(){
    addClassToElement(heroImage, "active")
  }, 200)
}

// let sectionThree = document.querySelectorAll(".section--three")[0]

// let button = document.querySelectorAll(".intro .button")[0]
// let pattern = document.querySelectorAll(".pattern")[0]
// let homeCover = document.querySelectorAll(".home-cover")[0]
// let header = document.querySelectorAll(".header")[0]
// let intro = document.querySelectorAll(".intro")[0]
// let wrap = document.querySelectorAll(".wrap")[0]


// /* Scroll Buttons */

// let navLinkPositions = document.querySelectorAll(".nav-link--positions")[0]
// let navLinkPeople = document.querySelectorAll(".nav-link--people")[0]
// let navLinkBlog = document.querySelectorAll(".nav-link--blog")[0]
// let buttonPositions = document.querySelectorAll(".button--positions")[0]

// let sectionPositions = document.querySelectorAll(".section-header--positions")[0]
// let sectionPeople = document.querySelectorAll(".section-header--people")[0]
// let sectionBlog = document.querySelectorAll(".section-header--blog")[0]

// if(buttonPositions) { buttonPositions.addEventListener('click', function(event){
//     animateScroll(sectionPositions, 1800, "easeInOutCubic", 0)
//     event.preventDefault()
//   })
// }
// if(navLinkPositions) { navLinkPositions.addEventListener('click', function(event){
//     animateScroll(sectionPositions, 1800, "easeInOutCubic", 0)
//     event.preventDefault()
//   })
// }
// if(navLinkPeople) { navLinkPeople.addEventListener('click', function(event){
//     animateScroll(sectionPeople, 1800, "easeInOutCubic", 0)
//     event.preventDefault()
//   })
// }
// if(navLinkBlog) { navLinkBlog.addEventListener('click', function(event){
//     animateScroll(sectionBlog, 1800, "easeInOutCubic", 0)
//     event.preventDefault()
//   })
// }

/* Demo Scroll */
//
// setTimeout(function(){
//   animateScroll(1400, 5000, "easeInOutCubic", 0, null, animateBack)
// }, 12000)
//
// function animateBack() {
//   setTimeout(function(){
//     console.log("hi");
//     animateScroll(-1398, 2000, "easeInOutCubic", 0)
//   }, 100)
// }

/* Popups */

let community = document.querySelectorAll(".item--dropdown-community")[0]

let popups = document.querySelectorAll(".popup-wrap")
let overlays = document.querySelectorAll(".popup-overlay")
let closeButtons = document.querySelectorAll(".popup__button--close")

let activePopup = null;
let activeOverlay = null;

community.addEventListener('click', function(event){
    showPopup(popups[0])
    event.preventDefault()
})

closeButtons.forEach((button) => {
  button.addEventListener('click', closeActivePopup)
})

overlays.forEach((overlay) => {
  overlay.addEventListener('click', closeActivePopup)
})

function showPopup(whichPopup) {
  activePopup = whichPopup
  addClassToElement(whichPopup, "popup--shown");
}

function closeActivePopup() {
  removeClassFromElement(activePopup, "popup--shown");
  activePopup = null;
}

/* Code highlighting */

function highlight() {	
  $('pre code').each(function(i, block) {	
    hljs.highlightBlock(block);	
  });	
}	
 $(document).ready(function() {	
  try {	
    highlight();	
  } catch(err) {	
    console.log("retrying...")	
    setTimeout(function() {	
      highlight();	
    }, 2500)	
  }	
  
  var clipboard = new ClipboardJS(".btn");	
  clipboard.on('success', function(e) {	
    var id = $(e.trigger).attr("data-clipboard-target");	
    $(id).toggleClass("flash");	
    setTimeout(function() {	
      $(id).toggleClass("flash");	
    }, 200);	
    e.clearSelection();	
  })	
})

/* Mobile Nav */

let moreLink = document.querySelectorAll(".item--more")[0]

let nav = document.querySelectorAll(".mobile-nav-wrap")[0]
let navOverlay = document.querySelectorAll(".mobile-nav-overlay")[0]
let navCloseButton = document.querySelectorAll(".mobile-nav-close")[0]


moreLink.addEventListener('click', function(event){
    showNav()
    event.preventDefault()
})

navCloseButton.addEventListener('click', closeNav)
navOverlay.addEventListener('click', closeNav)


function showNav() {
  addClassToElement(nav, "mobile-nav--shown");
}

function closeNav() {
  removeClassFromElement(nav, "mobile-nav--shown");
}


// new ScrollOver({
//   keyframes : [
//     {
//       element : sectionOne,
//       reveal:
//         {
//           when : 300,
//           className: "section--shown"
//         }
//     }
//   ]
//  }).init()


/*--- Utils ---*/
function addClassToElement(element, className) {
  (element.classList) ? element.classList.add(className) : element.className += ' ' + className
  return element
}

function removeClassFromElement(element, className) {
  if(element.classList) {
    element.classList.remove(className)
  } else {
    element.className = element.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ')
  }
  return element
}
