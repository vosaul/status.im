<li class="fiddle on">
  <img src="/fiddle/thumbnails/{{ fiddle.thumbnail }}" style="display: block; width: 200px; height: 200px; margin-bottom: 20px;" />
  <a href="{{ fiddle.link }}" class="fiddle-name" target="_blank">{{ fiddle.name }}</a>
  <p class="fiddle-desc">{{ fiddle.description }}</p>
  <div class="fiddle-tag-list">
    {% for tag in fiddle.tags %}
      <a href="#{{ tag }}" class="fiddle-tag">{{ tag }}</a>
    {% endfor %}
  </div>
</li>