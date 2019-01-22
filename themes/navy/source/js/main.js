/* global $ */
const moment = require('moment');

var addClassToElement = require('./shared-js/js/utils').addClassToElement;
var removeClassFromElement = require('./shared-js/js/utils').removeClassFromElement;

function formatDate(date) {
  const day = moment().date(date.get('date')).format('DD');
  const month = moment().month(date.get('month')).format('MMM');
  const hour = moment().hour(date.get('hour')).format('HH');
  const minute = moment().minute(date.get('minute')).format('mm');

  return `${day} ${month} at ${hour}:${minute}`;
}

function retrieveAdvocacyPrograms() {
  $.ajax({
    type: 'get',
    url: 'https://statusphere.status.im/api/v1/boards/public/?is_featured=true&org=375',
    success: function(response) {
      $.each(response, function(index, program) {
        var description = program.description.substr(0, 200) + '...';
        $('#advocacy-programs').prepend(
          `<div class="card">
            <a href="https://statusphere.status.im/b/${program.uuid}/view" class="card-inner">
              <div class="card-content">
                <h3>${program.title}</h3>
                <p class="secondary-text">${description}</p>
              </div>
              <div class="card-projects__link">
                <span class="link-arrow">Learn More</span>
              </div>
            </a>
          </div>`
        );
      });
    }
  });
}

function retrieveDiscussTopics() {
  $.ajax({
    type: 'get',
    url: 'https://discuss.status.im/latest.json',
    success: function(response) {
      const topics = response && response.topic_list && response.topic_list.topics;
      let numberOfInsertedTopics = 0;

      $.each(topics, function(index, topic) {
        if (!topic.pinned && numberOfInsertedTopics < 2) {
          const date = moment(topic.last_posted_at);

          $('#latest-announcements').prepend(
            `<div class="post">
                <time>
                  ${formatDate(date)}
                </time>
                <h4>
                  <a href="https://discuss.status.im/t/${topic.slug}/${topic.id}">
                    ${topic.title}
                  </a>
                </h4>
              </div>`
          );

          numberOfInsertedTopics += 1;
        }
      });
    }
  });
}

$(document).ready(function() {
  let url = 'https://our.status.im/ghost/api/v0.1/posts/?order=published_at%20desc&limit=2&formats=plaintext&client_id=ghost-frontend&client_secret=2b055fcd57ba';

  $.ajax({
    type: 'get',
    url: url,
    success: function(response) {
      response.posts = response.posts.reverse();

      $.each(response.posts, function(index, val) {
        const date = moment(val.published_at);

        $('.latest-news').prepend(
          `<div class="post">
            <time>${formatDate(date)}</time>
            <h4><a href="https://our.status.im/${val.slug}">${val.title}</a></h4>
          </div>`
        );
      });
    }
  });

  retrieveAdvocacyPrograms();
  retrieveDiscussTopics();
});

let heroImage = document.querySelectorAll(".hero-image")[0]

if(heroImage) {
  setTimeout(function(){
    addClassToElement(heroImage, "active")
  }, 200)
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
