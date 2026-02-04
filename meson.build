project(
  'ft_cloc',
  'vala',
  meson_version : '>= 1.0.0',
  version : '0.1',
  default_options : ['warning_level=2', 'optimization=3'],
  license : 'MIT'
)

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gio-2.0'),
]

sources = [
  'src/main.vala',
  'src/file_children.vala',
]

ft_cloc = executable(
  'ft_cloc',
  sources,
  dependencies : dependencies,
  install : true,
)
