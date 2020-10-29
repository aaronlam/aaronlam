---
title: 粗解TCP的流量控制和拥塞控制
date: 2019-06-30 20:00:00
tags:
  - TCP
  - 网络
  - 流量控制
  - 拥塞控制
categories:
  - 网络
---

# 流量控制

## 1. 什么是流量控制

在 TCP 传输中，如果数据发送方的发送速度过快，那么就会造成数据接收方来不及接收所有发送出的数据。那么在这样的状况下，就会有分组丢失的情况发生。控制数据发送方的发送速度，使得数据接收方来得及接收，这就是流量控制。

## 2. 流量控制的目的

流量控制的其根本目的就是防止 TCP 传输中的分组丢失，它是构成 TCP 可靠性传输的其中一个方面。

## 3. 如何实现流量控制

TCP 传输的流量控制由**滑动窗口协议**（[**连续 ARQ 协议**](https://zh.wikipedia.org/wiki/%E8%87%AA%E5%8A%A8%E9%87%8D%E4%BC%A0%E8%AF%B7%E6%B1%82)）实现的，滑动窗口协议既能保证分组无差错、有序接收，也实现了流量控制的功能。主要的方式就是接收方在返回的 ACK 中会包含自己的接收窗口大小，并利用该接收窗口大小来实现控制发送方的数据发送。

<!--more-->

---

# 拥塞控制

## 1. 什么是拥塞控制

拥塞控制是一种用来调整 TCP 链接单次发送分组数量（**单次发送量**，通常叫 cwnd）的算法

## 2. 拥塞控制的目的

拥塞控制的其根本目的是防止通信子网中某一部分的分组数量过多，使得该部分的网络来不及处理，导致该通讯子网乃至整个网络性能下降的现象发生。严重的话还会导致网络通信业务陷入停顿，既出现死锁的现象。

其实就是类似于平时深圳公路网中常见的交通拥挤一样，当节假日出行的车辆大量增加时，各种走向的车流互相干扰。不仅如此，还有各路段不停修路，最终导致的堵车。

## 3. 如何实现拥塞控制

在讲如何实现拥塞控制之前，需要介绍两个概念，第一个就是**拥塞窗口 cwnd**（**congestion window**），而第二个则是慢开始门限 **ssthresh**（**slow start thresh**）。**后面的内容将会用 cwnd 和 ssthresh 代指它们两个**，下面是对这两个概念的具体解释：

1. 发送方会维持一个拥塞窗口的状态变量，拥塞窗口的大小取决于网络的拥塞程度，并且会根据实际情况动态变化。发送方让自己的发送窗口大小等于拥塞窗口大小，另外考虑到接收方的接受能力，发送方的发送窗口可能还需要小于拥塞窗口。

2. 为了防止拥塞窗口增长过快，发送方还会维持一个慢开始门限变量，一旦到达慢开始门限的值后就会从慢开始算法转为执行拥塞避免算法。

### 1) 慢开始算法

慢开始算法的思路就是，不要一开始就发送大量的数据，先探测一下网络的拥塞程度，也就是由小到大逐渐增加 cwnd 的大小。从下图可以看到，一个传输轮次所经历的时间其实就是往返时间 RTT，而且每经过一个传输轮次，cwnd 就加倍。所以慢开始里的“慢”并不是指 cwnd 增长的速率慢，而是指在 TCP 传输开始发送报文段时，初始设置的 cwnd 较小，然后再指数式增大。这当然会比，在初始就设置为较大的 cwnd 一下子把许多报文段注入到网络中要“慢的多”。

![慢开始算法](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201026180823.png)

为了防止慢开始算法，让 cwnd 走上无止境的指数式增长的道路，上面提到的 ssthresh 就起到了关键的作用。ssthresh 的具体作用如下，所以在这里可以看出慢开始算法和拥塞避免算法在拥塞控制中是相辅相成的：

1. 当 **cwnd < ssthresh** 时，就执行慢开始算法；
2. 当 **cwnd > ssthresh** 时，就改为执行拥塞避免算法；
3. 当 **cwnd = ssthresh** 时，慢开始与拥塞避免算法任选。

### 2) 拥塞避免算法

拥塞避免算法的思路就是让 cwnd 缓慢增长，即每经过一个往返时间 RTT 就把发送方的 cwnd +1，而不是指数式的加倍。这样有助于 cwnd 按线性规律的缓慢增长。另外无论是在慢开始算法阶段还是拥塞避免算法阶段，只要发送方判断网络出现拥塞（主要是根据有没有定时的收到接收方的确认，虽然没有收到确认可能是其他原因造成的。但是无法判断具体原因，所以都当做拥塞来进行处理），就把 ssthresh 设置为出现拥塞时的发送窗口大小的一半（但不能小于 2），然后把 cwnd 重新置为 1，然后改为执行慢开始算法（这样做的目的是要迅速减少发送方发送到网络中的分组数，使得拥塞的网络中的路由器有足够的时间把积压的分组处理完毕）。

![拥塞避免算法](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201026183338.png)

1. cwnd 初始化为 1 个报文段，ssthresh 初始值为 16
2. 开始执行慢开始算法，指数增长到第 4 轮，既 cwnd=ssthresh=16，然后改为执行拥塞避免算法，cwnd 按加法增长（线性规律增长）
3. 假定 cwnd=24 时，网络出现超时（拥塞），则设置 ssthresh 为出现拥塞时的发送窗口大小的一半，既 ssthresh=12，cwnd 重新设置为 1，然后改为执行慢开始算法。当 cwnd=ssthresh=12 时，为避免拥塞，改为执行拥塞避免算法

### 2) 快重传算法

快重传算法的思路就是要求接收方在收到 1 个失序的报文段后就立即发出重复确认（为的是让发送方及早知道有报文段没有到达）。快重传算法规定，发送方只要一连收到 3 个重复确认（确认丢失段的前一个段）就应当立即重传对方尚未收到的报文段，而不必继续等待设置重传计时器时间到期。

![快重传算法](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201026185311.png)

### 4) 快恢复算法

快重传算法一般与快恢复算法配合使用，快恢复算法的思路就是当发送方连续收到 3 个重复确认时，就执行“乘法减少”算法，设置 ssthresh 为遇到突发情况时发送窗口大小的一半预防网络发生拥塞，考虑到如果网络出现了拥塞就不会接收到好几个重复确认，所以发送方认为现在网络可能没有出现拥塞。所以此时不执行慢开始算法，而是将 cwnd 设置为 ssthresh 减半后的值，然后改为执行拥塞避免算法，使 cwnd 缓慢增长。

![快恢复算法](https://cdn.jsdelivr.net/gh/aaronlam/imghosting/20201026190649.png)

---

# 总结

流量控制主要作用于接收方，它是控制发送方的发送速度从而使接受方能够来的急接收发送方所发送的数据，防止分组丢失的控制方法。由**滑动窗口协议**（**连续 ARQ 协议**）实现，滑动窗口协议既保证了分组无差错、有序接收，也实现了流量控制的功能。
拥塞控制则作用于网络，它是防止过多的数据注入到传输的网络中，避免网络负载过大的情况发生。常用的控制方法如下：

1. 慢开始算法+拥塞避免算法
2. 快重传算法+快恢复算法

另外，慢开始算法只是在 TCP 传输建立时和网络出现超时时才使用。