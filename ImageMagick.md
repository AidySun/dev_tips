# ImageMagick Usage

* list possible options: `convert -list gravity`

* resize: `convert -resize 120x120 in.png out.png`  
  - this would keep aspect ratio, the result may not be the one expected. To ignore the asped ratio using `\!`
    - `convert -resize 120x120\! in.png out.png`

* Crop : ` convert 1.jpg -gravity northeast  -crop 800x500+0+0 1111.jpg `

* split one image intot two (vertically): `convert -crop 50%x100% +repage input_image out%d_image`

* crop with fitting
  `convert 3000.png -resize 640x1136^ -gravity center -crop 640x1136+0+0 +repage 640x1136.png`

* append (+:horizontal -:vertical) : ` convert +append 1.png 2.png out.png `

* add white border: ` convert 1.jpg -border 2x2 11.jpg `

* convert format : `convert -format jpg input.gif input.jpg`
