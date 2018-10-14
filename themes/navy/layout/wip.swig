<div class="page-intro wrapper">
  <header class="article-header-wip">
    <div class="wip-intro">
      <h1>Work on a Better Web</h1>
      <p>Status has the fastest moving codebase of any project in Ethereum. Keep track of all we do here.</p>
      <br/>
    </div>
    <div class="wip-link-wrap">
      <a href="../developer_tools/">
        <div class="wip-link">
          <h3>Developer Tools</h3>
          <p>JS API and Extensions
            <a href="../developer_tools/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../build_status/">
        <div class="wip-link">
          <h3>Build Status</h3>
          <p>For mobile and desktop
            <a href="../build_status/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../research/">
        <div class="wip-link">
          <h3>Research</h3>
          <p>Dive in! Learn more...
            <a href="../research/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
    </div>
  </header>
</div>
<div id="content-wrap">
  <div id="content" class="wrapper">
    <div id="content-inner">
      <ul id="plugin-list">
        {% for wip in site.data[page.data] %}
          {{ partial('partial/' + page.partial, {wip: wip}) }}
        {% endfor %}
      </ul>
    </div>
  </div>
</div>