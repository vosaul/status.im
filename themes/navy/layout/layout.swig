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
      {{ partial('partial/shared-partials/partials/footer') }}
    {% endif %}
  </div>
  {{ partial('partial/shared-partials/partials/after_footer') }}
</body>
</html>
