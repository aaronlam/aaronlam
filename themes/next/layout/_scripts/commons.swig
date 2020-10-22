{%
  set js_commons = [
    'src/utils.js',
    'src/motion.js'
  ]
%}

{% if theme.jsdelivr_compress %}
{%
  set js_commons = [
    'src/utils.min.js',
    'src/motion.min.js'
  ]
%}
{% endif %}

{% for common in js_commons %}
  <script type="text/javascript" src="{{ url_for(theme.js) }}/{{ common }}?v={{ theme.version }}"></script>
{% endfor %}
