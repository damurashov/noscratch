file(MAKE_DIRECTORY build)

project(parser)
file(MAKE_DIRECTORY build/parser)
configure_file(src/parser/* build/parser COPYONLY)
configure_file(src/parser/flex)