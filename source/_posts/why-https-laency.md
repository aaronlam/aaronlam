---
title: 粗解为什么HTTPS需要七次握手
date: 2019-07-18 23:45:00
tags:
  - TCP
  - HTTPS
  - 网络
categories:
  - 网络
---

毋庸置疑，目前互联网世界里 HTTP 协议（Hypertext Transfer Protocol）已经是大家日常网上冲浪时最常用的应用层协议。但是，由于 HTTP 其本身主要就是用于传输超文本的网络协议，并不会保证所传输的数据是否安全可靠。所以，在使用 HTTP 协议进行密码数据传输时，就类似于在通往数据接收方的路上，走着一个衣服上写着密码内容的人。

![SSL发展史](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201104152419.png)

由于使用 HTTP 协议就如同让数据在大街上裸奔的原因，所以网景（Netscape）在 1995 年设计了 HTTPS 协议，使用了安全套接字层（Secure Sockets Layer：SSL）保证数据传输的安全可靠。随着传输层安全协议协议（Transport Layer Security）的发展，我们目前已经用 TLS 替代了废弃的 SSL 协议，而一般现在所说的 SSL 都是代指 TLS。

所以，可以说 HTTPS 是对 HTTP 协议的一种扩展，由于其基于了传输层的安全协议，我们得以可以使用它在互联网上安全地上网冲浪，传输私密数据等等。然而 HTTPS 从第一次发出建立连接请求到连接成功建立发送数据，**这中间需要七次握手存在 4.5 倍的往返延迟（Round-Trip Time：RTT），比 HTTP 要多出几倍。**所以，今天在这里就粗解一下其中的过程及其原因。

1. TCP 协议，通信双方三次握手建立 TCP 连接
2. TLS 协议，通信双方四次握手建立 TLS 连接
3. HTTP 协议，客户端向服务端发送请求，服务端反馈响应

我们可以从上面就可以看出，多出的往返延迟应该是在 TLS 协议的握手阶段产生出来的。而我们下面所做的分析都是建立在特定版本的协议实现以及常见场景上。因为，随着网络技术的发展，网络协议的迭代升级，一些新版本的协议已经通过新的机制优化掉多余通信往返，在后面我们会略带一提。

<!--more-->

# TCP

HTTP 协议作为应用层协议，它底下需要依赖传输层协议作为其提供数据传输功能的基础，而 HTTP 协议一般都会使用 TCP 协议作为其底层的传输层协议。为了阻止历史连接的错误建立，TCP 协议通信的双方会通过三次握手的机制进行连接的建立，而先前我已经写过一篇文章详细分析为什么 TCP 建立个连接得握三次手，在这里我们简单回顾一下 TCP 链接建立的整个过程。

![TCP三次通信建立连接](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201102140120.png)

1. 客户端向服务端发送含有 SYN 控制标识以及初始序列号 SEQNO 值为 100 的数据段
2. 服务端收到数据段后，向客户端发送含有 ACK、SYN 控制标识以及确认序列号 ACKNO 值为 101 和初始序列号 SEQNO 值为 200 的数据段
3. 客户端收到数据段后，向服务器发送含有 ACK 控制标识以及确认序列号 ACKNO 值为 201 的数据段

TCP 连接的双方会通过三次握手，确定 TCP 连接所需的初始序列号、窗口大小以及最大数据段，这样通信双方就能利用数据段中的序列号保证双方的数据不乱、不重、不漏，又通过窗口大小控制流量并以最大数据段大小控制自身所传输数据段的大小避免其下层 IP 协议对数据包进行分片。

以前 TCP 协议为了交换建立连接所需的信息迫不得已需要进行三次握手，甚至如今大多数场景下也是无法避免。不过在 2014 年所提出的 TCP 开启（TCP Fast Open：TFO）却可以在某些特定场景下通过一次通信建立 TCP 连接。

![TCP Fast Open](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201104174440.png)

TCP 快启使用的策略是 TCP 连接建立之初，客户端在向服务端发送含有 SYN 控制标识以及初始序列号值的数据段时会在其数据段内标记快启选项，服务器收到数据段后，会生成一个 TFO Cookie 并将其放在包含 ACK、SYN 控制标识以及确认序列号值和初始化序列号值的数据段中发往客户端，客户端收到数据段后会把 Cookie 储存下来。当客户端与服务端重新建立连接时，它会发送含有 SYN 控制标识以及初始序列号值和所存储的 Cookie 的数据段重新与服务端建立 TCP 连接，服务端校验客户端数据段内所携带的 Cookie 无误后，就向客户端发送含有 ACK、SYN 控制标识以及确认序列号值和初始化序列号值的数据段，随后开始传输数据，这样下来就能在后续的连接建立中减少通信的次数。

# TLS

由于 TLS 其本身并不提供传输的可靠性保障，所以 TLS 是构建在 TCP 协议之上的，用以在 TCP 协议上构建安全的传输通道。在通信双方建立可靠的 TCP 协议连接之后，就需要通过 TLS 握手交换双方的密钥，在这里我们主要介绍 TLS 1.2 版本的连接建立的握手过程。

![TLS四次握手](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201104191345.png)

1. 客户端向服务端发送 Client Hello 消息，其中携带客户端所支持的协议版本、加密算法、压缩算法以及客户端生成的随机字符串
2. 服务端收到客户端支持的协议版本、加密压缩算法等信息后
   1. 向客户端发送 Server Hello 消息，并携带特定的协议版本、加密算法、压缩算法、会话 ID、服务端生成的随机数
   2. 向客户端发送 Certificate 消息，即：网站证书链，其中包含证书所证明的网站域名、签署方、有效期等信息
   3. 向客户端发送 Server Key Exchange 消息，传递公钥以及签名等信息
   4. 向客户端发送可选的 CertificateRequest 消息，要求验证客户端的证书
   5. 向客户端发送 Server Hello Done 消息，通知服务端已经发送了全部的相关信息
3. 客户端收到服务端的协议版本、加密算法、压缩算法、网站证书等等信息，校验网站证书无误后
   1. 向服务器发送 Client Key Exchange 消息，包含使用服务端公钥加密后的随机字符串，即：预主密钥（Pre Master Key）
   2. 向服务端发送 Change Cipher Spec 消息，通知服务端后续的数据会使用加密传输
   3. 向服务端发送 Finished 消息，其中包含加密后的握手信息
4. 服务端收到客户端的 Change Cipher Spec 和 Finished 消息后
   1. 向客户端发送 Change Cipher Spec 消息，通知客户端后面的数据段会使用加密传输
   2. 向客户端发送 Finished 消息，验证客户端的 Finished 消息并完成 TLS 握手

TLS 握手的关键在于利用通信双发生成的随机字符串和服务端的证书公钥生成一个双方经过协商后的对称密钥，这样通信双方就可以使用这个对称密钥在后续的数据传输中加密消息数据，防止中间人的监听和攻击，保证通讯安全。

而在 TLS1.2 中，我们需要 2 RTT 才能建立 TLS 连接，但是 TLS 1.3 经过优化协议，将原本两次往返延迟降低至一次，大幅度减少了建立 TLS 连接所需要的时间和资源，让客户端可以在 1 RTT 之后就能立即向服务端传输应用层的消息数据，而在这里就不详细介绍 TLS 1.3 是如何建立连接的了。除了减少常规的握手开销外，TLS 1.3 还引入了 0 RTT 连接建立的特性，可以让原本的 40% 的连接可以通过该特性建立连接，而该特性与 TCP 协议的 TFO 的实现原理较为相似，其策略都是通过存储会话信息和重用会话信息来实现的，所以存在一定的安全风险。

# HTTP

在已经建立好的 TCP 和 TLS 的通道上传输数据是很简单的事情了，HTTP 协议可以直接利用其下层可靠且安全的连接通道进行数据传输。TCP 解决了数据不乱、不重、不漏，而 TLS 解决了数据的安全问题，可谓铜墙铁壁般。由于 HTTP 是通过 TCP 的套接字接口向服务端写入消息数据，服务端在接受到数据且处理后会通过相同的途径返回消息数据。因为整个过程需要客户端发送请求以及服务端返回相应，所以整个流程是需要 1 RTT。

![HTTP请求响应](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201104191348.png)

由于进行数据交换的操作时 1 RTT 已经是极限，所以 HTTP 协议本身已经是没有可优化的空间了。不过随着请求的数量逐渐增加，利用 HTTP/2 就可以复用已经建立的 TCP 连接减少 TCP 和 TLS 握手带来的额外开销。

# 总结

如文章一开始所提到的，HTTPS 需要七次握手，其中各层中所需要的握手次数情况如下：

1. TCP 协议，通信双方三次握手建立 TCP 连接
2. TLS 协议，通信双方四次握手建立 TLS 连接
3. HTTP 协议，客户端向服务端发送请求，服务端反馈响应

TCP 协议通过三次握手，确定建立连接所需的初始序列号、窗口大小以及最大数据段，这样通信双方就能利用数据段中的序列号保证双方的数据不乱、不重、不漏，又通过窗口大小控制流量并以最大数据段大小控制自身所传输数据段的大小避免其下层 IP 协议对数据包进行分片。TLS 协议通过四次握手，交换建立安全连接中所需的协议版本、加密算法、压缩算法、客户端服务端随机数、网站证书等信息，依据这些信息来协商出后续数据传输中所需要的对称加密密钥。HTTP 再利其下层的 TLS 与 TCP 所建立好的安全可靠的连接通道进行消息的发送和接收。

# 延伸阅读

- [为什么 TCP 建立个连接得握三次手](/2019/03/01/why-tcp-connection-need-three-way-handshake/)
- [粗解 TCP 的流量控制和拥塞控制](/2019/06/30/tcp-traffic-and-congestion-control/)
- [为什么 TCP/IP 要拆分我的数据](/2019/05/31/why-tcp-ip-protocol-fragemented-my-packet/)
- [为什么 TCP 要粘我的数据包](/2019/04/04/why-tcp-sticky-my-packet/)