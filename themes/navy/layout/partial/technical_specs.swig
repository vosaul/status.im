<li class="plugin on">
  <img src="/technical_specs/thumbnails/{{ technical_specs.thumbnail }}" style="display: block; width: 200px; height: 200px; margin-bottom: 20px;" />
  <a href="{{ technical_specs.link }}" class="plugin-name" target="_blank">{{ technical_specs.name }}</a>
  <p class="plugin-desc">{{ technical_specs.description }}</p>
  <div class="plugin-tag-list">
    {% for tag in technical_specs.tags %}
      <a href="#{{ tag }}" class="plugin-tag">{{ tag }}</a>
    {% endfor %}
  </div>
</li>