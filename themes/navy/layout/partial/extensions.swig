<li class="extensions on">
  <img src="/extensions/thumbnails/{{ extensions.thumbnail }}" style="display: block; width: 200px; height: 200px; margin-bottom: 20px;" />
  <a href="{{ extensions.link }}" class="extensions-name" target="_blank">{{ extensions.name }}</a>
  <p class="extensions-desc">{{ extensions.description }}</p>
  <div class="extensions-tag-list">
    {% for tag in extensions.tags %}
      <a href="#{{ tag }}" class="extensions-tag">{{ tag }}</a>
    {% endfor %}
  </div>
</li>