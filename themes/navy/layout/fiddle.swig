<div class="page-intro wrapper">
  <header class="article-header-first-page">
    <div class="first-page-intro">
      <h1>Build a Better Web</h1>
      <p>Begin your journey to a more secure and distributed internet here.</p>
      <br/>
    </div>
    <div class="first-page-link-wrap">
      <a href="../developer_tools/">
        <div class="first-page-link">
          <h3>Developer Tools</h3>
          <p>JS API and Extensions
            <a href="/developer_tools/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../build_status/">
        <div class="first-page-link">
          <h3>Build Status</h3>
          <p>For mobile and desktop
            <a href="/build_status/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../technical_specs/">
        <div class="first-page-link">
          <h3>Research</h3>
          <p>Dive in! Learn more...
            <a href="/technical_specs/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../security/">
        <div class="first-page-link">
          <h3>Security</h3>
          <p>Status best practices
            <a href="/security/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../wip/">
        <div class="first-page-link">
          <h3>Work in Progress</h3>
          <p>All our WIP items
            <a href="/wip/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="https://embark.status.im/">
        <div class="first-page-link">
          <h3>Embark</h3>
          <p>Better Ðapps for everyone
            <a href="https://embark.status.im/">
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
        {% for fiddle in site.data[page.data] %}
          {{ partial('partial/' + page.partial, {fiddle: fiddle}) }}
        {% endfor %}
      </ul>
    </div>
  </div>
</div>