# Shoots
Shoots 是一款开源的截图管理软件，也是[「做个应用」](https://apps.apple.com/cn/app/id1578873606)里的开源课程，跟着这个应用，作为一个 0 基础的小白也可以做一个自己的应用，关于新手学习 SwiftUI 更多的内容可以查看应用。

<summary>iOS 端截图</summary>

![Group 380](https://user-images.githubusercontent.com/3838258/229984956-5ce8ad63-d32f-4477-917b-8c5726a2b567.png)



<details>
<summary>iPad 和 Mac 端截图</summary>
     
![2](https://user-images.githubusercontent.com/3838258/229985027-50356625-73bd-4719-8eb2-062ce91066b7.png)
     
</details>




# 需求描述
1.  每个人的手机里都存在这大量的应用的截图，当我们希望找下某个应用的截图或者某个设计模式的截图做参考的时候很难找到，大量的截图哪些需要删除哪些需要保留也很难整理。
2.  当我们在做设计的时候，希望查看下同类型的应用是如何设计的，或者相似模块都有哪些设计模式，因此如果有个可以搜查类似产品设计的产品可以满足这个需求点。

# 解决方案
因此 Shoots 应用希望解决应用截图管理的问题，满足以下几个问题：
- 可以按照应用分类管理截图
- 可以按照截图里的设计模式分类管理截图
- 可以收藏产品设计模式比较好的应用的截图

# 整体设计
整体的设计内容可以查看[ Figma 原始文件](https://www.figma.com/file/uq7cAfob875rL61xQyLsPJ/SwiftUI-%E7%9B%B4%E6%92%AD%E5%BC%80%E5%8F%91%E9%A1%B9%E7%9B%AE?node-id=618%3A723&t=drNbLhVnEiqN59I2-1)。

# 更多内容
关于需求可以查看我们的 [Notion 需求列表](https://productpoke.notion.site/b1b9e7130e504e289832732a33670e5c)。

# 如何使用
可以点击右上角的绿色 Code 按钮，下拉里会有三个选项：
- Open with Github Desktop：使用 Github 桌面端 Clone 下载代码
- Open with Xcode：使用 Xcode 自带的管理器 Clone 下载代码
- Download ZIP：下载代码压缩吧

如果后续这个库的代码更新之后，前面两种方式可以更新电脑上的代码，而最后一种则需要手动下载代码。建议直接使用第二种方法，按照引导进行设置即可。

# 关于SwiftUI
SwiftUI 是苹果最近几年新推出的 Apple 全平台 UI 开发框架，一套代码可以运行在 iPhone、iPad、Mac、Apple Watch 和 Apple TV 上，极大的节省了开发成本，同时也保持了应用的一致性。

SwiftUI 是一种声明式语言，我们可以一点点给元素添加属性修改元素的样式，可以看到下面就是一个按钮的样式和实现代码。

SwiftUI 去除了复杂的设计，所有看到的元素都是 View，一个页面，一个按钮，一个文字，一个输入框都是一个 View，极大的减少了对代码的理解成本，更加容易学习，真正可以做到一看就会。

#### 更多的 SwiftUI 内容可以查看[「做个应用」](https://apps.apple.com/cn/app/id1578873606)，涉及到应用开发个各个方面。

## 适合什么样的人？
SwiftUI 适合所有对互联网产品有基础常识的人，只要你知道基础的应用控件，知道 NavigationView、Tabbar，就可以很简单的看懂 SwiftUI 的技术代码，之所以起名为 SwiftUI For Beginners 是因为设计师对产品的设计比较了解，可以更好的开发出易用的产品。
下面这个你看得懂吗？

```swift
NavigationView {
     ScrollView {
           Text("如果你能看到这段代码就可以学会 SwiftUI！")
                  .font(.system(size: 16, weight: .bold))
                  .foregroundColor(Color.red)
            Button {
                   print("Email: 834599524@qq.com")
             } label: {
                   Text("联系我们")
             }
      }.navigationTitle("SwiftUI For Beginners")
}
```
如果你对互联网产品不是很了解，学习技术不是难点，让自己想做的产品符合用户使用习惯是难点，对于产品设计可以多参考类似产品，而对于 UI 元素的设计可以使用 Figma，是一款基于浏览器的设计工具，简单易用，同时社区有很多设计资源可以更好的帮助你设计出色的应用。


## 关于小白学习技术
这个应用目的在于教会 0 基础的小白学习代码进行开发应用，无论是产品设计师、UI 和平面设计师，在整体产品设计上能力相对比较好，如果自己会一些代码就可以很好的满足自己一些小工具上的需求，有个良好的推广也会成为一款热门应用。

国内著名的设计师开发应用当属于由 [@Utom](https://twitter.com/utom) 开发的 Sketch 下的设计交付工具 [Sketch Measure](https://github.com/utom/sketch-measure)，作为 Sketch 下从设计到技术交付的著名第三方插件帮助了非常多的设计师。


# 联系我们
有任何问题请邮箱联系。
📮：834599524@qq.com

# License
Shoots 基于 MIT 开源协议。[查看详细信息](https://github.com/xiaoxidong/Shoots/blob/main/LICENSE)
