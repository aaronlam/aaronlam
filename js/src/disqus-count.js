var DISQUSWIDGETS, disqus_domain, disqus_shortname;
typeof DISQUSWIDGETS === "undefined" &&
  (DISQUSWIDGETS = (function () {
    var f = document,
      e = {},
      s = f.head || f.body,
      j = {},
      q = { identifier: 1, url: 2 };
    e.getCount = function (b) {
      var c;
      c = encodeURIComponent;
      var a = "//corsapi.aaronlam.xyz/aaronlam.disqus.com/count-data.js?",
        d = [],
        k = 0,
        l = 10,
        r = "",
        b = b || {};
      b.reset && ((j = {}), (r = "&_=" + +new Date()));
      for (
        var b = [
            f.getElementsByTagName("A"),
            (f.getElementsByClassName &&
              f.getElementsByClassName("disqus-comment-count")) ||
              [],
          ],
          m,
          i,
          g,
          h,
          n = 0;
        n < b.length;
        n++
      ) {
        m = b[n];
        for (var o = 0; o < m.length; o++) {
          i = m[o];
          g = i.getAttribute("data-disqus-identifier");
          h =
            (i.hash === "#disqus_thread" &&
              i.href.replace("#disqus_thread", "")) ||
            i.getAttribute("data-disqus-url");
          if (g) h = q.identifier;
          else if (h) (g = h), (h = q.url);
          else continue;
          var p;
          j.hasOwnProperty(g)
            ? (p = j[g])
            : ((p = j[g] = { elements: [], type: h }),
              d.push(c(h) + "=" + c(g)));
          p.elements.push(i);
        }
      }
      d.sort();
      for (c = d.slice(k, l); c.length; )
        (b = f.createElement("script")),
          (b.src = a + c.join("&") + r),
          (b.async = 1),
          s.appendChild(b),
          (k += 10),
          (l += 10),
          (c = d.slice(k, l));
    };
    e.displayCount = function (b) {
      for (var c, a, d, e = b.counts, b = b.text.comments; (c = e.shift()); )
        if ((a = j[c.id])) {
          switch (c.comments) {
            case 0:
              d = b.zero;
              break;
            case 1:
              d = b.one;
              break;
            default:
              d = b.multiple;
          }
          c = d.replace("{num}", c.comments);
          a = a.elements;
          for (d = a.length - 1; d >= 0; d--) a[d].innerHTML = c;
        }
    };
    return e;
  })());
DISQUSWIDGETS.getCount();
