<div class="page-intro wrapper">
  <header class="article-header-fiddle">
    <div class="fiddle-intro">
      <h1>Fiddle with Functional Components</h1>
      <p>Play with our tools and actually learn how to build a better web!</p>
      <br/>
    </div>
    <div class="fiddle-link-wrap">
      <a href="../developer_tools/">
        <div class="fiddle-link">
          <h3>Developer Tools</h3>
          <p>JS API and Extensions
            <a href="/developer_tools/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../build_status/">
        <div class="fiddle-link">
          <h3>Build Status</h3>
          <p>For mobile and desktop
            <a href="/build_status/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="https://embark.status.im/">
        <div class="fiddle-link">
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
      {{ partial('partial/sidebar') }}
      <article class="article-container" itemscope itemtype="http://schema.org/Article">
        <div class="article-inner">
          <div class="article">
            <div class="inner">
              <div class="article-content" itemprop="articleBody">
                {{ page_anchor(page.content) }}
              </div>
              <footer class="article-footer">
                <time class="article-footer-updated" datetime="{{ date_xml(page.updated) }}" itemprop="dateModified">{{ __('page.last_updated', date(page.updated)) }}</time>
                {{ page_nav() }}
              </footer>
            </div>
          </div>
        </div>
      </article>
    </div>
  </div>
</div>