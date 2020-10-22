{%
  set boot_scripts = [
    'src/bootstrap.js'
  ]
%}

{% if theme.jsdelivr_compress %}
{%
  set boot_scripts = [
    'src/bootstrap.min.js'
  ]
%}
{% endif %}

{% for bs in boot_scripts %}
  <script type="text/javascript" src="{{ url_for(theme.js) }}/{{ bs }}?v={{ theme.version }}"></script>
{% endfor %}
