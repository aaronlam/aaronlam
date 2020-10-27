{% if not (theme.duoshuo and theme.duoshuo.shortname) and not theme.duoshuo_shortname %}
  {% if theme.disqusjs.enable %}

    {% if theme.disqusjs.count  %}
      <script id="dsq-count-scr" src="{{ url_for(theme.js) }}/src/disqus-count.min.js?v={{ theme.disqusjs.version }}" async></script>
    {% endif %}

    {% if page.comments %}
      <script>
        function loadDisqusJS() {
          var d = document, s = d.createElement('script');
          s.src="{{ url_for(theme.js) }}/src/disqus.min.js?v={{ theme.disqusjs.version }}"
          s.async = 1; // 保证异步加载
          s.setAttribute('data-timestamp', +new Date());
          (d.head || d.body).appendChild(s);
          s.onload = s.onreadstatechange = function() {
            // 保证IE及非IE都能正常script监听onload事件
            if(!this.readyState || this.readyState == "loaded" || this.readyState == "complete") {
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
            }
          }
        }

        // 判断当前环境是否为浏览器
        var runningOnBrowser = typeof window !== "undefined";
        // 通过检查全局对象的scroll属性及检查userAgent判断当前访问者是否为爬虫
        var isSpiderBot = (runningOnBrowser && !("onscroll" in window)) || (typeof navigator !== "undefined" && /(gle|ing|ro|msn)bot|crawl|spider|yand|duckgo/i.test(navigator.userAgent));
        // 判断当前浏览器是否支持IntersectionObserver API
        var supportIntersectionObserver = runningOnBrowser && "IntersectionObserver" in window;
      
        setTimeout(function() {
          if(!isSpiderBot && supportIntersectionObserver) {
            var disqusJSObserver = new IntersectionObserver(function(entries) {
              // 对应监控元素已出现在显示视窗中
              if(entries[0].isIntersecting) {
                // 加载DisqusJS
                loadDisqusJS();
                // 停止继续监控
                disqusJSObserver.disconnect();
              }
            }, { threshold: [0] });
            // 设置监控的元素
            disqusJSObserver.observe(document.getElementById('disqus_thread'));
          } else {
            // 当前访问者为爬虫或者当前浏览器不支持IntersectionObserver API
            loadDisqusJS();
          }
        })
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
