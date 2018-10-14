<div class="page-intro wrapper">
  <header class="article-header-build">
    <div class="build-intro">
      <h1>Build a Better Web</h1>
      <p>Begin your journey to a more secure and distributed internet here.</p>
      <br/>
    </div>
    <div class="build-link-wrap">
      <a href="../developer_tools/">
        <div class="build-link">
          <h3>Developer Tools</h3>
          <p>JS API and Extensions
            <a href="/developer_tools/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../research/">
        <div class="build-link">
          <h3>Research</h3>
          <p>Dive in! Learn more...
            <a href="/research/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../nightly/">
        <div class="build-link">
          <h3>Nightlies</h3>
          <p>Get our latest builds
            <a href="../nightly/">
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
          <aside id="article-toc" role="navigation">
            <div id="article-toc-inner">
              <strong class="sidebar-title">{{ __('page.contents') }}</strong>
              {{ toc(page.content, {list_number: false}) }}
              <a href="#" id="article-toc-top">{{ __('page.back_to_top') }}</a>
            </div>
          </aside>
        </div>
      </article>
    </div>
  </div>
</div>
