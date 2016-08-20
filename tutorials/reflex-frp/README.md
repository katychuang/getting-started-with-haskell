# Reflex examples

For these examples you will need to install reflex-platform.

```
$ git clone git@github.com:reflex-frp/reflex-platform.git
$ ./try-reflex
```

Once you're in the nix shell, you can run the command `ghcjs file.hs` as it'll compile the haskell code into a single page application.

---
## Examples

1. NASA Picture of the Day api client
2. Type Ahead autocomplete
3. using CSS
4. rendering SVG


### 1. nasa-pod.hs

You'll need to get an API key first, from [https://api.nasa.gov](https://api.nasa.gov). Then with this key you can enter it into the textbox in the compiled gui. This example is also available at [reflex-examples](https://github.com/reflex-frp/reflex-examples/blob/master/nasa-pod/workshop.hs).

![](static/nasa-pod.jpg)

This example was from a live-coding workshop at the NY Haskell Users Group by Ali Abrar.

---

### 2. Type Ahead autocomplete

Code is available from [@ali-abrar][https://gist.github.com/ali-abrar/2a52593f3a391d82c40f439d4894f017]

This example was from a live-coding workshop at the NY Haskell Users Group by Ali Abrar.

---

### 3. using CSS

![](static/css.jpg)

This example was from @katychuang

---

### 4. rendering SVG

![](static/svg.jpg)

This example was from @katychuang
