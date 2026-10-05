# ft_cloc
[cloc](https://github.com/AlDanial/cloc) but it's my own version in vala


## dependencies

- [vala](https://vala.dev/)
- [glib](https://gitlab.gnome.org/GNOME/glib/)
    - gobject include in glib
    - gio include in glib

## install

mesonbuild is require to install for build this project
if you don't have meson : 

```sh
# With pip3
pip3 install --user meson
```

otherwise go to this page : [Meson](https://mesonbuild.com/Getting-meson.html)

```sh
meson setup build
sudo meson install -C build
```
