<div class="page-intro wrapper">
  <header class="article-header-contribute">
    <div class="contribute-intro">
      <h1>Contribute to a Better Web</h1>
      <p>It's all about the people, after all</p>
      <br/>
    </div>
    <div class="contribute-link-wrap">
      <a href="life_status.html">
        <div class="contribute-link">
          <h3>Life at Status</h3>
          <p>Day-to-day decentralization
            <a href="life_status.html">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="our_principles.html">
        <div class="contribute-link">
          <h3>Our Principles</h3>
          <p>A principled approach
            <a href="our_principles.html">
              <img src="../img/arrow_blue_shaded.svg" />
            </a>
          </p>
        </div>
      </a>
      <a href="jobs.html">
        <div class="contribute-link">
          <h3>Working Here</h3>
          <p>See our open positions!
            <a href="jobs.html">
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
