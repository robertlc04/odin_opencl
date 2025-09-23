# Example
This basic example it's for showing mathematic fuctions(Parametric Functions) generating images
It's not the better approuch but works. The encode used for generating this image it's [PPM](https://en.wikipedia.org/wiki/Netpbm)
```sh
  odin run .
```

### Recommendation
Having ffmpeg or another program for encode the image to JPEG or PNG it's useful

### Image Generated
![Parametric Curve](.image.jpg "Parametric Curve")

### Equation Used
```
  Curve 1
  x=5cos(t)+3cos( (5/3)*t)
  y=5cos(t)-3cos( (5/3)*t)

  Curve 2
  x=11cos(t)+7cos( (11/5)*t)
  y=11cos(t)-7cos( (11/5)*t)
  
```
