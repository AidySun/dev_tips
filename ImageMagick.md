# ImageMagick Usage


* Crop : ` convert 1.jpg -gravity northeast  -crop 800x500+0+0 1111.jpg `

* append (+:horizontal -:vertical) : ` convert +append 1.png 2.png out.png `

* add white border: ` convert 1.jpg -border 2x2 11.jpg `

* convert format : `convert -format jpg input.gif input.jpg`
