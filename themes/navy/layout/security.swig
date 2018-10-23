<div class="page-intro wrapper">
  <header class="docs-header">
    <div class="docs-intro">
      <h1>Securing a Better Web</h1>
      <p>Self-reliance is critical in distributed systems. Learn how here.</p>
      <br/>
    </div>
    <ul>
      <li>
        <div class="inner">
          <h3>Guides</h3>
          <p>Become a security ninja</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="../guides/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Policy and Procedure</h3>
          <p>This is how we do!</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="../org_sec/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Audits</h3>
          <p>See who guards the guards</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="/audits/"></a>
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
