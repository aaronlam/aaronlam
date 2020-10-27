{% if not (theme.duoshuo and theme.duoshuo.shortname) and not theme.duoshuo_shortname %}
  {% if theme.disqusjs.enable %}

    {% if theme.disqusjs.count  %}
      <script id="dsq-count-scr" src="{{ url_for(theme.js) }}/src/disqus-count.min.js?v={{ theme.disqusjs.version }}" async></script>
    {% endif %}

    {% if page.comments %}
      <script src="{{ url_for(theme.js) }}/src/disqus.min.js?v={{ theme.disqusjs.version }}"></script>
      <script>
        var dsqjs = new DisqusJS({
            shortname: '{{ theme.disqusjs.shortname }}',
            siteName: '{{ theme.disqusjs.siteName }}',
            identifier: document.location.origin + document.location.pathname + document.location.search,
            url: document.location.origin + document.location.pathname + document.location.search,
            title: document.title,
            api: '{{ theme.disqusjs.api }}',
            apikey: ['3tSA13Wd42mFImQZH1JerSBXZjvKLvKrdhEplfG5k1dL6cmine6bV1UsmhizFvyJ', 'c9nomZ32wB7pDogCbRuTqrY2OKGcJzOXeN1ZNZVCQvSdO5KGerxLNiAdcaMgMKvY', '2jtVcNm4XvnISFqQiiLmjNgt2lramSks68WAnyASnteVzMRnLFYCXSiudbrpoNLr', 'SnBHyhy1pSbmPgKXMATfPUOv3Q2WWuAkv0JS2LjLVUrjZGWQeJdMQhlJUJow6ufb', 'a0tgOWx5UOuVR4jHitN6HA9SZPg61JCynHEx0ZCd7bYR5BhrqQRE15ph00Dl3L1i', '75iOeCKL8JTvz9pX1zqXKcqXsdmHITL9IhmSDbw4WhYMlRod2v5LlJEIPgwyMy92', 'NLPPSIXr0gAgtVhsyDPraicrQh1nSlgGKbkkl09GpYcpapvDbgWsQDpV2pTpyHHX', 'u9eBGtFAZJyv5YJatlkzZRswrlFFuJnfZwaAk3sSS3szKRkBcOKr6smJa7AIbyNB', 'BFHqakwhtPD8Iy2SkjX6Ip0bitnlXuH2QIyYhNM3czJyNp6Os1UnV1DdigYHtMIY', 'SlAHfNK44AyAaMJC3lqvls5LfAyHgHdXbJOglPw6imBarYCbwY88KfjkZ1dttmIE'],
            admin: '{{ theme.disqusjs.admin }}',
            adminLabel: '{{ theme.disqusjs.adminLabel }}'
        });
      </script>
    {% endif %}
    
  {% endif %}

  {% if theme.disqus.enable %}

    {% if theme.disqus.count  %}
      <script id="dsq-count-scr" src="https://{{theme.disqus.shortname}}.disqus.com/count.js" async></script>
    {% endif %}

    {% if page.comments %}
      <script type="text/javascript">
        var disqus_config = function () {
          this.page.url = '{{ page.permalink }}';
          this.page.identifier = '{{ page.path }}';
          this.page.title = '{{ page.title| addslashes }}';
        };
        var d = document, s = d.createElement('script');
        s.src = 'https://{{theme.disqus.shortname}}.disqus.com/embed.js';
        s.setAttribute('data-timestamp', '' + +new Date());
        (d.head || d.body).appendChild(s);
      </script>
    {% endif %}

  {% endif %}
{% endif %}
