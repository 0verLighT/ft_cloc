project(
  'ft_cloc',
  'vala',
  meson_version : '>= 0.63.0',
  version : '0.1',
  default_options : ['warning_level=2', 'optimization=3'],
  license : 'MIT'
)

conf_data = configuration_data()
conf_data.set('VERSION', meson.project_version())
version_file = configure_file(
  input: 'version.vala.in',
  output: 'version.vala',
  configuration: conf_data,
)

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gio-2.0'),
]

sources = files(
  'src/ft_cloc.vala',
)

sources += version_file

ft_cloc = executable(
  'ft_cloc',
  sources,
  dependencies : dependencies,
  install : true,
)
