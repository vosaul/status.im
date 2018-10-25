<div class="page-intro wrapper">
  <header class="docs-header">
    <div class="docs-intro">
      <h1>Extend into a Better Web</h1>
      <p>Status Extensions will literally blow your mind</p>
      <br/>
    </div>
    <ul>
      <li>
        <div class="inner">
          <h3>Try Yourself!</h3>
          <p>Literally, right now...</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="/developer_tools/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Fiddle</h3>
          <p>Play with even more</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="../fiddle/"></a>
      </li>
      <li>
        <div class="inner">
          <h3>Developer Tools</h3>
          <p>#MakeCodingGreatAgain</p>
        </div>
        <img src="../img/arrow_blue_shaded.svg" />
        <a href="../developer_tools/"></a>
      </li>
    </ul>
  </header>
</div>
<div id="content-wrap">
  <div id="content" class="wrapper">
    <div id="content-inner">
      <article class="article-container" itemscope itemtype="http://schema.org/Article">
        <div class="article-inner">
          <div class="article">
            <div class="inner">
              <div class="article-content" itemprop="articleBody">
                <div id="wrapper">
                    <main>
                        <div id="content"></div>
                        <div id="errors"></div>
                    </main>
                    <aside id="panel">
                        <p>A playground to experiment with extensions and easily publish them on IPFS. <br /> Go ahead, modify the default extension on the left side!</p>
                        <p>Find more details about building your own extension in this <a href="https://docs.status.im/docs/extensions_tutorial_chat_command.html">tutorial</a></p>
                        <button class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect" onclick="publish()">Publish</button>
                        <div id="qr-wrapper"></div>
                    </aside>
                </div>
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


<!-- Extensions -->
<script defer src="https://code.getmdl.io/1.3.0/material.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/codemirror@5.40.2/lib/codemirror.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/codemirror@5.40.2/mode/clojure/clojure.js"></script>
<script src="https://cdn.jsdelivr.net/npm/parinfer@3.12.0/parinfer.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/parinfer-codemirror@1.4.2/parinfer-codemirror.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/ipfs/dist/index.min.js"></script>
<script src="https://cdn.rawgit.com/neocotic/qrious/master/dist/qrious.js"></script>
<script src="/js/extensions/pluto.js"></script>
<script>
    const ipfs = new window.Ipfs();

    async function load() {
      const buffer = await loadIPFS(ipfs, "QmWKqSanV4M4zrd55QMkvDMZEQyuHzCMHpX1Fs3dZeSExv");
      return buffer.toString();
    }

    ipfs.once("ready", async () => {
      const content = await load();
      codeMirror.setValue(content);
    })

    function extensionLink(hash) {
      return "https://get.status.im/extension/ipfs@" + hash;
    }

    async function loadIPFS(ipfs, hash) {
      return ipfs.files.cat(hash);
    }

    async function publish() {
      const content = codeMirror.getValue();
      const filesAdded = await uploadIPFS(ipfs, content);
      displayQR(extensionLink(filesAdded[0].hash));
    }

    function clearErrors() {
      const elErrors = document.getElementById("errors");
      elErrors.innerHTML = '';
      elErrors.className = "";
    }

    function displayErrors(errors) {
      const elErrors = document.getElementById("errors");
      if (errors == null) {
        elErrors.innerHTML = '<div>No errors</div>';
        elErrors.classList.add("ok");
      } else {
        elErrors.classList.add("errors");

        let names = errors.map( (error, i) => {
          return [error.type, error.value]
        })
        var s = '<div>Errors</div><ul>';
        names.forEach(function(element) {
          s = s.concat("<li>" + element[0]);
          if (element[1] != null) {
            s = s.concat(":" + JSON.stringify(element[1]));
          }
          s = s.concat("</li>");
        });
        s = s.concat("</ul>")
        elErrors.innerHTML = s;
      }
    }

    function uploadIPFS(ipfs, s) {
      return ipfs.files.add({path: 'extension.edn',
                            content: ipfs.types.Buffer.from(s, 'utf8')})
    }

    function clearQR() {
      const qel = document.getElementById("qr-wrapper");
      qel.innerHTML = '';
    }

    function displayQR(s) {
      const qel = document.getElementById("qr-wrapper");
      qel.innerHTML = '<canvas id="qr"></canvas><a href="' + s + '">Universal link</a>';
      new QRious({
            element: document.getElementById('qr'),
            value: s,
            size: 250
      });
    }
  </script>
  <script>
    const codeMirror = CodeMirror(document.getElementById("content"));
    codeMirror.setValue("Loading content ...");
    codeMirror.on("change", function(c, change) {
      clearErrors();
      clearQR();
      const read = pluto.reader.read(codeMirror.getValue());
      const readJS = pluto.js.from_clj(read);
      displayErrors(readJS.errors);
      if (readJS.errors == null) {
        const parsed = pluto.js.parse(read);
        const parsedJS = pluto.js.from_clj(parsed);
        displayErrors(parsedJS.errors);
      }
    });
    parinferCodeMirror.init(codeMirror);
  </script>