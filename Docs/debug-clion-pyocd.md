# Clion PyOCD Configure

Please download and install PyOCD first.

<img src="debug-clion-pyocd/image-20240121211255909.png" alt="image-20240121211255909" style="zoom: 80%;" />

<img src="debug-clion-pyocd/image-20240121211434382.png" alt="image-20240121211434382" style="zoom: 80%;" />

You can keep the default settings for now. Later on, we will configure the target ourselves.(Misc/pyocd.yaml)

<img src="debug-clion-pyocd/image-20240121211527071.png" alt="image-20240121211527071" style="zoom:80%;" />

<img src="debug-clion-pyocd/image-20240121211613733.png" alt="image-20240121211613733" style="zoom:80%;" />

```
gdbserver -p 33462 --config Misc\pyocd.yaml
```
