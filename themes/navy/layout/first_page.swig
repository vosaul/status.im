<div class="page-intro wrapper">
  <header class="docs-header docs-header-first-page">
    <div class="docs-intro">
      <h1>Documenting a Better Web</h1>
      <p>Education is the most powerful gift.</p>
    </div>
    <ul>
      <li>
        <div class="inner">
          <h3>Developer Tools</h3>
          <p>#MakeCodingGreatAgain</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="/developer_tools/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Build Status</h3>
          <p>For mobile and desktop</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="/build_status/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Embark</h3>
          <p>Better Ðapps for everyone</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="https://embark.status.im/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Research</h3>
          <p>Dive in! Learn more...</p>
        </div>
        <img  src="../img/arrow_blue_shaded.svg" />
        <a href="/research/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Security</h3>
          <p>Status best practices</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="/security/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Work in Progress</h3>
          <p>All our WIP items</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="/wip/"></a>
      </li>
    </ul>
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
