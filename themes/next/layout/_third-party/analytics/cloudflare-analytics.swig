{% if theme.cloudflare_analytics %}
  <script type="text/javascript">
    var _hmt = _hmt || [];
    (function() {
      var hm = document.createElement("script");
      hm.src = "https://static.cloudflareinsights.com/beacon.min.js";
      hm.dataset.cfBeacon = "{'token': '{{ theme.cloudflare_analytics }}'}"
      var s = document.getElementsByTagName("script")[0];
      s.parentNode.insertBefore(hm, s);
    })();
  </script>
{% endif %}
