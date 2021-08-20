# PDF Color Split

### Uses

+ 一个pdf 根据颜色(黑白/彩色)拆分为多个PDF(批量)
+ 根据每页pdf的颜色(黑白/彩色),  给PDF文件重命名, 规则为有一页为彩色就命名为彩色(批量)

### Exsample

+ recognize and rename

![recognize.jpg](https://i.loli.net/2021/08/20/RF3dViQ6KWmwZLl.jpg)

+ recognize and splite

![split.jpg](https://i.loli.net/2021/08/20/Csr5IfKv3DbGZi9.jpg)



### 原理

+ 通过 PDFium 把每页PDF转换为图片, 通过遍历图片的颜色来判断

+ 如果没有设置色彩偏差, 颜色RGB(255,255,254)也会判断为彩色, 虽然他真的很白

  ![color.jpg](https://i.loli.net/2021/08/20/qeOpkQIwnd3KLFm.jpg)

+ 如果填色彩偏差 计算将变为:

  ```
  (abs(R-B)>offset) or (abs(R-G)>offset) or (abs(B-G)>offset) 
  ```

  即各个颜色的差差不得大于offset