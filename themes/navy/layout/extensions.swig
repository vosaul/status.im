<div class="page-intro wrapper">
  <header class="article-header-extensions">
    <div class="extensions-intro">
      <h1>Extend into a Better Web</h1>
      <p>Status Extensions will literally blow your mind</p>
      <br/>
    </div>
    <div class="extensions-link-wrap">
      <a href="./try.html">
        <div class="extensions-link">
          <h3>Try Yourself!</h3>
          <p>Literally, right now...
            <a href="/developer_tools/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../fiddle/">
        <div class="extensions-link">
          <h3>Fiddle</h3>
          <p>Play with even more
            <a href="../fiddle/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../developer_tools/">
        <div class="extensions-link">
          <h3>Developer Tools</h3>
          <p>JS API and Extensions
            <a href="../developer_tools/">
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