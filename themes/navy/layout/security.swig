<div class="page-intro wrapper">
  <header class="article-header-security">
    <div class="security-intro">
      <h1>Securing a Better Web</h1>
      <p>Self-reliance is critical in distributed systems. Learn how here.</p>
      <br/>
    </div>
    <div class="security-link-wrap">
      <a href="../guides/">
        <div class="security-link">
          <h3>Guides</h3>
          <p>Become a security ninja
            <a href="../guides/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../org_sec/">
        <div class="security-link">
          <h3>Policy and Procedure</h3>
          <p>This is how we do!
            <a href="../org_sec/">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="../audits/">
        <div class="security-link">
          <h3>Audits</h3>
          <p>See who guards the guards
            <a href="/audits/">
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
