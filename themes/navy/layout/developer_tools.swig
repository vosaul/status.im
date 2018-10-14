<div class="page-intro wrapper">
  <header class="article-header-dev-tools">
    <div class="dev-tools-intro">
      <h1>Developer Tools for a Better Web</h1>
      <p>Become a master of distributed crafts with all our surprises for developers</p>
      <br/>
    </div>
    <div class="dev-tools-link-wrap">
      <a href="../developer_tools/">
        <div class="dev-tools-link">
          <h3>Developer Tools</h3>
          <p>JS API and Extensions
            <a href="/developer_tools/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../build_status/">
        <div class="dev-tools-link">
          <h3>Build Status</h3>
          <p>For mobile and desktop
            <a href="/build_status/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../research/">
        <div class="dev-tools-link">
          <h3>Research</h3>
          <p>Dive in! Learn more...
            <a href="/research/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../security/">
        <div class="dev-tools-link">
          <h3>Security</h3>
          <p>Status best practices
            <a href="/security/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../wip/">
        <div class="dev-tools-link">
          <h3>Work in Progress</h3>
          <p>All our WIP items
            <a href="/wip/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="https://embark.status.im/">
        <div class="dev-tools-link">
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
