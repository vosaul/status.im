<!DOCTYPE html>
<html lang="{{ page.lang }}">
{{ partial('partial/head') }}
<body>
  <div id="container">
    {% if page.source != 'index.md' %}
      {{ partial('partial/header') }}
    {% endif %}
    {{ body }}
    {% if page.source == 'index.md' %}
      {{ partial('partial/footer-home') }}
    {% else %}
      {{ partial('partial/footer') }}
    {% endif %}
  </div>
  {{ partial('partial/after_footer') }}
</body>
</html>
